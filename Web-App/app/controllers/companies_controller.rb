class CompaniesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_users, only: [:index, :new, :create]
  #before_action :set_company, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :only => [:show, :edit, :update, :destroy]

  def index
    @companies = Company.order(:name).all
  end


  # GET /companies/1
  # GET /companies/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @company }
    end
  end

  def recordings
    @company = Company.find(params[:id])
    @recordings = @company.recordings.active
    # If a valid sorting option is specified, then order it.
    params[:order] ||= "-created_at"
    if ['-created_at', '+created_at', '+title', '+created_by', '+sharing_approved','-sharing_approved'].include? params[:order]
      order_dir = (params[:order][0] == "-") ? "desc" : "asc"
      order_string = params[:order][1..-1]
      if order_string == "created_by"
        order_string = "email"
      end
      @recordings = @recordings.order("#{order_string} #{order_dir}")
    end
    render 'recordings/index'
  end

  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render json: @company, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /companies/1/edit
  def edit
  end

  def new
    @company = Company.new
  end


  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update

    s3 = AWS::S3.new
    bucket = s3.buckets[AWS_CONFIG['aws_bucket']]

    # handle whitelabel image et. al.
    [:whitelabel_icon, :header_image, :footer_image, :watermark_image, :company_logo].each do |file_handle|

      if params[:company][file_handle] && params[:company][file_handle] == '' # delete the image

        params[:company][(file_handle.to_s+"_url").to_sym] = nil

        # remove image from S3
        begin
          url = @company.send(file_handle.to_s+"_url")
          uri = URI.parse(url)
          puts bucket.objects[File.basename(uri.path)].delete
        rescue => e
          Rails.logger.info "error removing client image from S3!: #{e.to_s}"
        end

      elsif params[:company][file_handle]

        image = params[:company][file_handle]

        if image.content_type == "image/jpeg"
          ext = "jpg"
        elsif image.content_type == "image/png"
          ext = "png"
        elsif image.content_type == "video/mp4"
          ext = "mp4"
        end
        new_file_name = "#{Rails.env}/#{file_handle.to_s}-#{@company.id}.#{ext}"

        bucket.objects[new_file_name].write(image.read, {:acl => :public_read, :cache_control => 'max-age=315569000', :content_type => image.content_type})
        s3url = "http://#{AWS_CONFIG['aws_bucket_url']}/#{new_file_name}"
        params[:company][(file_handle.to_s+"_url").to_sym] = s3url
      end

    end

    respond_to do |format|
      if @company.update(company_params)
        @company.users.each do |user|
          user.update_attribute(:plan_id, @company.default_plan_id)
        end
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_path
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      if current_user.is_admin?
        return params.require(:company).permit(:name, :plan_id, :whitelabel_text, :whitelabel_icon_url, :watermark_image_url, :header_image_url, :footer_image_url, :company_logo_url, :default_plan_id, :contract_start_date, :contract_end_date, :allow_uploads, :simplified_workflow, :request_user_email, :videos_require_approval)
      else
        return params.require(:company).permit(:name, :plan_id, :whitelabel_text, :whitelabel_icon_url, :watermark_image_url, :header_image_url, :footer_image_url, :company_logo_url)
      end
    end
end

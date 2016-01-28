class RecordingsController < ApplicationController

  before_filter :authenticate_user!, :except => [:play]
  load_and_authorize_resource :except => [:play, :create]

  # GET /recordings
  # GET /recordings.json
  def index

    # If the user is NOT a super admin
    # AND the user is an account admin to at least one company
    if !current_user.is_admin? && current_user.is_a_account_admin?
      @recordings = Recording.where(created_by: current_user.user_ids_can_control, status: Recording::STATUS_NORMAL).joins(:user)
    else
      @recordings = current_user.recordings.joins(:user).active.all
    end

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

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @recordings }
    end

  end

  # GET /recordings/1
  # GET /recordings/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recording }
    end
  end

  def play

    @recording = Recording.find(params[:id])

    unless @recording.active
      redirect_to '/404.html'
      return
    end

    if params[:token] != @recording.token
      raise "Not allowed"
    end

    unless params[:increment] == "false"
      vr = ViewRecord.where(recording_id: @recording.id, view_date: Date.today).first_or_initialize
      vr.view_count += 1
      vr.save
    end

    @show_close_icon = (params[:return]) ? true : false

    render :layout => 'player'
  end

  # GET /recordings/new
  def new
    @recording = Recording.new
  end

  # GET /recordings/1/edit
  def edit
  end

  # POST /recordings
  # POST /recordings.json
  def create

    @recording = Recording.new(recording_params)
    @recording.created_by = current_user.id

    respond_to do |format|
      if @recording.save
        redirect = params[:manage_image] ? recording_palette_images_path(@recording) : edit_recording_path(@recording)
        format.html { redirect_to redirect, notice: 'Recording was successfully created.' }
        format.json { render json: @recording, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @recording.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recordings/1
  # PATCH/PUT /recordings/1.json
  def update
    respond_to do |format|
      if @recording.update(recording_params)
        redirect = nil
        if current_user.is_admin? && @recording.companies.first
          redirect = recordings_company_path(@recording.companies.first)
        else
          redirect = recordings_path
        end
        redirect = recording_palette_images_path(@recording) if params[:manage_image]
        format.html { redirect_to redirect, notice: 'Recording was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @recording.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recordings/1
  # DELETE /recordings/1.json
  def destroy
    @recording.status = Recording::STATUS_DELETED
    @recording.deleted_at = Time.now
    @recording.save
    respond_to do |format|
      redirect_path = current_user.is_admin? ? recordings_company_path(@recording.companies.first) : recordings_path
      format.html { redirect_to redirect_path, notice: 'Recording was successfully deleted.'  }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_recording
    @recording = Recording.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def recording_params
    if current_user.is_a_account_admin?
      params.require(:recording).permit(:template_id, :created_by, :presentation_template_id, :script, :title, :sharing_approved)
    else
      params.require(:recording).permit(:template_id, :created_by, :presentation_template_id, :script, :title)
    end
  end
end

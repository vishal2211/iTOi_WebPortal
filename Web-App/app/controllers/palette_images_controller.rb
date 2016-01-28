class PaletteImagesController < ApplicationController
  before_action :set_palette_image, only: [:show, :edit, :update, :destroy]
  before_action :set_recording

  respond_to :html

  def index
    @palette_images = @recording.palette_images
    respond_with(@palette_images)
  end

  def show
    respond_with(@palette_image)
  end

  def new
    @palette_image = PaletteImage.new
    respond_with(@palette_image)
  end

  def edit
  end

  def create
    s3 = AWS::S3.new
    bucket = s3.buckets[AWS_CONFIG['aws_bucket']]
    files = params[:upload_file]
    if files && files.size > 0
      files.each do |image|
        palette_image = PaletteImage.new(recording: @recording)
        if image.content_type == "image/jpeg"
          ext = "jpg"
        elsif image.content_type == "image/png"
          ext = "png"
        elsif image.content_type == "video/mp4"
          ext = "mp4"
        end
        new_file_name = "#{Rails.env}/palette-image-#{@recording.id}-#{rand.to_s[2..10]}.#{ext}"
        bucket.objects[new_file_name].write(image.read, {:acl => :public_read, :cache_control => 'max-age=315569000', :content_type => image.content_type})
        s3url = "http://#{AWS_CONFIG['aws_bucket_url']}/#{new_file_name}"
        palette_image.image_url = s3url
        palette_image.save!
      end
    else
      flash[:alert] = 'Please select atleast one image to upload'
    end
    redirect_to recording_palette_images_path(@recording)
  end

  def destroy
    @palette_image.destroy
    redirect_to recording_palette_images_path(@recording)
  end

  private
    def set_palette_image
      @palette_image = PaletteImage.find(params[:id])
    end

    def set_recording
      @recording = Recording.find(params[:recording_id])
    end

    def palette_image_params
      params.require(:palette_image).permit(:recording_id)
    end
end

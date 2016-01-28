class MediaItemController < ApplicationController

  def create
    @recording = Recording.find(params[:recording_id])
    @image = @recording.recording_images.create(attachment: params[:file], user_id: current_user.id)
    if @site_upload.save
      render json: {message: "success",  model_type: "site_uploads", fileID: @site_upload.id, site_id: @site.id}, :status => :ok
    else
      render json: {error: @site_upload.errors.full_messages.join(", ")}, :status => 400
    end

  end

  def destroy
    @upload = SiteUpload.find(params[:id])
    if @upload.destroy
      render json: { message: "File deleted from server" }
    else
      render json: { message: @upload.errors.full_messages.join(',') }
    end
  end

end
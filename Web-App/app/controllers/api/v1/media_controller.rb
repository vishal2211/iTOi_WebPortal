class Api::V1::MediaController < Api::V1::BaseController

  before_filter :authenticate_user!

  # POST /api/v1/media
  def create
    media = MediaItem.create(allowed_attributes)
    if media.valid?
      render json: media, status: 201, serializer: MediaSerializer and return
    else
      render json: {message: "Could not create recording: #{media.errors.full_messages.join(", ")}"}, status: 400 and return
    end
  end

  def destroy
    media = MediaItem.find(params[:id])
    authorize! :manage, media

    media.destroy
    render json: {}, status: 200
  end

  def index
    media = []
    current_user.companies.each do |company|
      company.media_items.all.each do |mi|
        media << mi
      end
    end
    render json: media, each_serializer: MediaSerializer
  end

  protected

  def allowed_attributes
    params[:media_item].permit(:name, :media_url, :company_id)
  end

end

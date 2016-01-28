class Api::V1::RecordingsController < Api::V1::BaseController

  before_filter :authenticate_user!

  # POST /api/v1/recordings
  def create
    attribs = params[:recording]
    attribs[:created_by] = current_user.id

    if params[:recording][:recording_images]
      attribs[:recording_images_attributes] = []
      params[:recording][:recording_images].each do |ri|
        attribs[:recording_images_attributes] << ri
      end
    end

    images = []
    if params[:recording][:palette_images]
      params[:recording][:palette_images].each do |pi|
        images << pi
      end
      params[:recording][:palette_images] = nil
    end

    recording = Recording.create(allowed_attributes(attribs))

    images.each do |image|
      PaletteImage.create(recording: recording, image_url: image)
    end

    if recording.valid?
      recording.transcode!
      if current_user.company && current_user.company.videos_require_approval?
        recording.sharing_approved = false
        recording.save
      end
      render json: recording, status: 201 and return
    else
      render json: {message: "Could not create recording: #{recording.errors.full_messages.join(", ")}"}, status: 400 and return
    end
  end

  # GET /api/v1/recordings/2
  def show
    recording = Recording.find(params[:id])
    authorize! :manage, recording

    render json: recording
  end

  # PUT /api/v1/recordings/1
  def update

    recording = Recording.find(params[:id])
    prior_video_url = recording.video_url
    authorize! :manage, recording

    attribs = params[:recording]

    if params[:recording][:palette_images]
      params[:recording][:palette_images].each do |pi|
        palette_image = recording.palette_images.where(image_url: pi).first
        if !palette_image
          PaletteImage.create(recording: recording, image_url: pi)
        end
      end
      params[:recording][:palette_images] = nil
    end

    recording_image_ids = recording.recording_images.map{|ri| ri.id}
    posted_image_ids = []

    if params[:recording][:recording_images]
      attribs[:recording_images_attributes] = []
      params[:recording][:recording_images].each do |ri|
        attribs[:recording_images_attributes] << ri
        posted_image_ids << ri[:id] if ri[:id]
      end
    end

    removed_image_ids = recording_image_ids - posted_image_ids
    removed_image_ids.each do |to_destroy|
      image_to_remove = RecordingImage.find(to_destroy)
      image_to_remove.destroy
    end

    recording.reload
    recording.update_attributes(allowed_attributes(attribs))
    if recording.valid?
      begin
        if recording.video_url != prior_video_url
          recording.transcode!
        end
      rescue => e
        Rails.logger.error "Transcoding error for #{recording.id}: #{e.to_s}"
      end
      render json: recording, status: 201 and return
    else
      render json: {message: "Could not update recording: #{recording.errors.full_messages.join(", ")}"}, status: 400 and return
    end
  end

  def destroy
    recording = Recording.find(params[:id])
    authorize! :manage, recording

    recording.status = Recording::STATUS_DELETED
    recording.deleted_at = Time.now
    recording.save

    render json: {}, status: 200
  end

  def index
    recordings = current_user.recordings.active
    render json: recordings, each_serializer: LightRecordingSerializer
  end

  def stats

    stats = []

    start_date = nil
    end_date = nil
    begin
      start_date = Time.parse(params[:start]).to_date
    rescue
      start_date = 30.days.ago.to_date
    end

    begin
      end_date = Time.parse(params[:end]).to_date
    rescue
      end_date = Time.now.to_date
    end

    Recording.where(created_by: current_user.user_ids_can_control, status: Recording::STATUS_NORMAL).each do |recording|

      data = []

      (start_date..end_date).each do |date|
        count = ViewRecord.where(recording_id: recording.id, view_date: date).first
        data << {date: date.strftime("%Y/%m/%d"), count: (count ? count.view_count : 0)}
      end

      stats << {
          recording: {
              id: recording.id,
              title: recording.title
          },
          data: data
      }

    end

    render json: {
        start: start_date.strftime("%Y/%m/%d"),
        end: end_date.strftime("%Y/%m/%d"),
        stats: stats
    }

  end

  protected

  def allowed_attributes(obj)
    obj.permit(:template_id, :created_by, :id, :title, :script, :scroll_speed, :duration, :video_url, :thumbnail_url, :video_background_color, :expected_length, :font_size, :youtube_url, :palette_images => [], :recording_images_attributes => [:id, :associated_string, :image_url, :start_time, :end_time, :scroll_height, :scroll_y_value])
  end

end

# == Schema Information
#
# Table name: recordings
#
#  id                       :integer          not null, primary key
#  template_id              :integer
#  created_by               :integer
#  presentation_template_id :integer
#  title                    :string(255)      default(""), not null
#  created_at               :datetime
#  updated_at               :datetime
#  font_size                :integer          default(40), not null
#  expected_length          :decimal(10, 3)   default(0.0)
#  script                   :text
#  scroll_speed             :integer          default(55)
#  video_url                :string(255)
#  status                   :integer          default(0), not null
#  thumbnail_url            :string(255)
#  duration                 :decimal(10, 3)   default(0.0), not null
#  video_background_color   :string(255)      default("0/0/0")
#  parse_id                 :string(255)
#  parse_video_uuid         :string(255)
#  youtube_url              :string(255)
#  transcoded_video_url     :string(255)
#  transcoder_job_id        :string(255)
#  transcoder_error_message :string(255)
#  palette_images           :text
#  deleted_at               :datetime
#  sharing_approved         :boolean          default(TRUE), not null
#

class RecordingSerializer < ActiveModel::Serializer

  #cached
  #delegate :cache_key, to: :object

  attributes :id, :template_id, :created_by, :created_at, :presentation_template_id, :title, :expected_length, :font_size, :scroll_speed, :script, :video_background_color,  :video_url, :duration, :youtube_url, :play_url, :play_count, :thumbnail_url, :transcoded_video_url, :sharing_approved, :palette_images
  has_many :recording_images

  def play_count
    object.view_records.sum(:view_count)
  end

  def palette_images
    object.palette_images.pluck(:image_url)
  end

end

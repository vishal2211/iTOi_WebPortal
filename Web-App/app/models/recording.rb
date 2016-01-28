require 'digest/md5'
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
#  user_email               :string(255)
#  sharing_approved         :boolean          default(TRUE), not null
#

class Recording < ActiveRecord::Base

  STATUS_NORMAL = 0
  STATUS_DELETED = 1

  belongs_to :user, :foreign_key => :created_by, touch: true
  has_many :recording_images
  has_many :view_records

  accepts_nested_attributes_for :recording_images
  validates_associated :recording_images

  scope :active, -> { where(status: STATUS_NORMAL)}
  scope :has_video_attached, -> { where("video_url is not null")}

  has_many :companies, through: :user
  has_many :palette_images
  validates_presence_of :expected_length

  def is_draft?
    self.video_url.nil? || self.video_url.empty?
  end

  def shares

  end

  def active
    status == STATUS_NORMAL
  end

  def play_count
    ViewRecord.where(recording_id: self.id).sum(:view_count)
  end

  # security token so people can't just browse to random videos with GET url changes
  def token
    Digest::MD5.hexdigest("#{id}#{created_at}")
  end

  def play_url
    if Rails.env == "development"
      root_url = "http://localhost:3000/"
    elsif Rails.env == "staging"
      root_url = "http://staging.seeitoi.com/"
    else
      root_url = "https://manage.seeitoi.com/"
    end
    "#{root_url}/recordings/#{id}/play/#{token}"
  end

  def cdn_video_url
    transcoded_video_url ? transcoded_video_url : video_url
  end

  def transcode!

    return false unless self.video_url

    basename = video_url.split("/").last

    transcoder = AWS::ElasticTranscoder::Client.new
    job = transcoder.create_job(
        pipeline_id: '1427383126529-zi49kv',
        input: {
            key: basename,
            frame_rate: 'auto',
            resolution: 'auto',
            aspect_ratio: 'auto',
            interlaced: 'auto',
            container: 'auto'
        },
        output: {
            key: "trans-#{id}-#{Time.now.to_i}.mp4",
            preset_id: '1351620000000-100070',
            thumbnail_pattern: "",
            rotate: '0'
        }
    )

    # remove old transcoded url while we generate the new one
    # destroy the s3 object as well
    remove_transcoded_video!

    self.transcoder_job_id = job[:job][:id]
    save

  end

  def permanently_delete!
    remove_transcoded_video!
    remove_original_video!
    self.destroy
  end

  private

  def remove_transcoded_video!

    if self.transcoded_video_url

      begin
        s3 = AWS::S3.new
        bucket = s3.buckets['itoi-output']
        basename = transcoded_video_url.split("/").last
        object = bucket.objects[basename]
        object.delete
      rescue => e
        Rails.logger.error e.to_s
      end

      self.transcoded_video_url = nil

    end

  end

  def remove_original_video!

    if self.video_url

      begin
        s3 = AWS::S3.new
        bucket = s3.buckets['iTOi.producer.videos']
        basename = video_url.split("/").last
        object = bucket.objects[basename]
        object.delete
      rescue => e
        Rails.logger.error e.to_s
      end

      self.video_url = nil

    end

  end

end

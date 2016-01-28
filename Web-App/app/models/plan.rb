# == Schema Information
#
# Table name: plans
#
#  id                        :integer          not null, primary key
#  name                      :string(255)      not null
#  created_at                :datetime
#  updated_at                :datetime
#  default_plan              :boolean          default(FALSE), not null
#  max_video_length_seconds  :integer          default(0), not null
#  total_video_space_minutes :integer          default(0), not null
#  video_filters             :integer          default(0), not null
#  can_download              :boolean          default(FALSE), not null
#  video_quality             :integer          default(0), not null
#  youtube_share             :boolean          default(FALSE), not null
#  custom_watermark          :boolean          default(FALSE), not null
#  custom_header_graphic     :boolean          default(FALSE), not null
#  custom_footer_graphic     :boolean          default(FALSE), not null
#  video_analytics           :boolean          default(FALSE), not null
#

class Plan < ActiveRecord::Base

  PLAN_CID_BRONZE    = 1
  PLAN_CID_SILVER    = 2
  PLAN_CID_GOLD      = 3
  PLAN_CID_PLATINUM  = 4
  PLAN_CID_UNLIMITED = 5

  VIDEO_QUALITY_SD = 0
  VIDEO_QUALITY_HD = 1

  has_many :users
  validates_presence_of :name

  def permissions
    {
      max_video_length_seconds: max_video_length_seconds,
      total_video_space_minutes: total_video_space_minutes,
      video_filters: video_filters,
      can_download: can_download?,
      video_quality: video_quality == Plan::VIDEO_QUALITY_HD ? 'HD' : 'SD',
      youtube_share: youtube_share?,
      custom_watermark: custom_watermark?,
      custom_header_graphic: custom_header_graphic?,
      custom_footer_graphic: custom_footer_graphic?,
      video_analytics: video_analytics?
    }
  end

end

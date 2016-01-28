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

class PlanSerializer < ActiveModel::Serializer
  #cached
  #delegate :cache_key, to: :object

  attributes :name, :permissions
end

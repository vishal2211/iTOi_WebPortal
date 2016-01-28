# == Schema Information
#
# Table name: recording_images
#
#  id                :integer          not null, primary key
#  associated_string :text             not null
#  image_url         :string(255)      not null
#  start_time        :decimal(10, 3)   not null
#  end_time          :decimal(10, 3)   not null
#  scroll_height     :integer          not null
#  scroll_y_value    :integer          not null
#  recording_id      :integer
#  created_at        :datetime
#  updated_at        :datetime
#  parse_id          :string(255)
#

class RecordingImage < ActiveRecord::Base
  belongs_to :recording, touch: true

 validates_presence_of :associated_string, :image_url, :start_time, :end_time, :scroll_height, :scroll_y_value
end

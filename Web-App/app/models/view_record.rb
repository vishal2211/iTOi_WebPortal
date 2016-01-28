# == Schema Information
#
# Table name: view_records
#
#  id           :integer          not null, primary key
#  recording_id :integer          not null
#  view_date    :date             not null
#  view_count   :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

class ViewRecord < ActiveRecord::Base
  belongs_to :recording
end

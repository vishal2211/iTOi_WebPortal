# == Schema Information
#
# Table name: sharing_outputs
#
#  id          :integer          not null, primary key
#  company_id  :integer          not null
#  oauth_token :string(255)      not null
#  output_type :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class SharingOutput < ActiveRecord::Base

  OUTPUT_TYPE_YOUTUBE  = 0
  OUTPUT_TYPE_TWITTER  = 1
  OUTPUT_TYPE_FACEBOOK = 2

  validates_presence_of :company
  validates_presence_of :oauth_token
  validates_presence_of :output_type

  belongs_to :company

end

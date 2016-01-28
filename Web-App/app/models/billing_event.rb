# == Schema Information
#
# Table name: billing_events
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  previous_plan_id :integer          not null
#  new_plan_id      :integer          not null
#  billing_source   :integer          not null
#  token            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class BillingEvent < ActiveRecord::Base

  BILLING_SOURCE_IAP = 0
  BILLING_SOURCE_WEB = 1

  #@TODO: Add foreign_key constraint in billing_events table after Rails upgrade to version 4.2
  belongs_to :user, foreign_key: true

  validates :previous_plan_id, :new_plan_id, :billing_source, presence: true

end

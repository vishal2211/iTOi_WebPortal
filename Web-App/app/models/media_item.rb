# == Schema Information
#
# Table name: media_items
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  media_url  :string(255)      not null
#  company_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class MediaItem < ActiveRecord::Base
  validates_presence_of :media_url, :name, :company_id
  belongs_to :company
end

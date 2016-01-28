# == Schema Information
#
# Table name: templates
#
#  id                       :integer          not null, primary key
#  created_by               :integer          not null
#  presentation_template_id :integer
#  title                    :string(255)      not null
#  tag_url                  :string(255)      not null
#  watermark_url            :string(255)      not null
#  left_sidebar_url         :string(255)
#  right_sidebar_url        :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#

class Template < ActiveRecord::Base
  has_many :company_templates
  belongs_to :user, :foreign_key => :created_by
  has_many :companies, through: :company_templates, source: 'company'
end

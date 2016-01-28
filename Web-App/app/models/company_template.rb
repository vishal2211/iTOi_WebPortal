# == Schema Information
#
# Table name: company_templates
#
#  id          :integer          not null, primary key
#  template_id :integer          not null
#  company_id  :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class CompanyTemplate < ActiveRecord::Base
  belongs_to :company
  belongs_to :template
end

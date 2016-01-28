# == Schema Information
#
# Table name: company_users
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  company_id  :integer          not null
#  permissions :integer          default(0), not null
#  created_at  :datetime
#  updated_at  :datetime
#

class CompanyUser < ActiveRecord::Base
  belongs_to :company
  belongs_to :user
  ##belongs_to :nowuser

  def is_admin?
    self.permissions == 1
  end

end

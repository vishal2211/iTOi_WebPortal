# == Schema Information
#
# Table name: companies
#
#  id                      :integer          not null, primary key
#  name                    :string(255)      not null
#  created_at              :datetime
#  updated_at              :datetime
#  company_token           :string(255)
#  whitelabel_icon_url     :string(255)
#  whitelabel_text         :string(255)
#  header_image_url        :string(255)
#  footer_image_url        :string(255)
#  watermark_image_url     :string(255)
#  company_logo_url        :string(255)
#  default_plan_id         :integer
#  contract_start_date     :date
#  contract_end_date       :date
#  allow_uploads           :boolean          default(TRUE), not null
#  simplified_workflow     :boolean          default(FALSE), not null
#  request_user_email      :boolean          default(FALSE), not null
#  videos_require_approval :boolean          default(FALSE), not null
#

class Company < ActiveRecord::Base

  has_many :company_users, dependent: :destroy
  has_many :company_templates, dependent: :destroy
  has_many :sharing_outputs, dependent: :destroy

  has_many :users, through: :company_users, source: 'user'
  has_many :templates, through: :company_templates, source: 'template'
  has_many :media_items, dependent: :destroy

  # lol I'm surprised this works
  has_many :recordings, through: :users

  belongs_to :default_plan, :class_name => "Plan", :foreign_key => 'default_plan_id'
  belongs_to :now_user, :class_name=>"NowUser", :foreign_key=>'company_id'

  validates_presence_of :name

  before_create :generate_company_token

  private

  def generate_company_token
    self.company_token = Digest::SHA1.hexdigest((Time.now.to_i + rand(1..999)).to_s) unless self.company_token
  end

end

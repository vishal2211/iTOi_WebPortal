# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  plan_id                :integer          not null
#  is_admin               :boolean          default(FALSE), not null
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  status                 :integer          default(0), not null
#  plan_expiration        :date
#  parse_id               :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :invitable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :company_token

  has_many :company_users
  has_many :companies, :through => :company_users, :source => 'company'
  has_many :recordings, :foreign_key => :created_by
  has_many :templates, :foreign_key => :created_by
  belongs_to :plan
  ##belongs_to :now_user

  STATUS_ACTIVE = 0
  STATUS_DELETED = 1

  self.per_page = 100

  default_scope { where(status: STATUS_ACTIVE) }
  scope :active, -> { where(status: STATUS_ACTIVE) }

  after_create :validate_company_token
  before_create :set_plan

  def total_views
    count = 0
    Recording.where(created_by: user_ids_can_control, status: Recording::STATUS_NORMAL).each do |rec|
      rec.view_records.each do |vr|
        count += vr.view_count
      end
    end
    return count
  end

  def total_seconds
    count = 0
    Recording.where(created_by: user_ids_can_control, status: Recording::STATUS_NORMAL).each do |rec|
      count += rec.expected_length
    end
    return count
  end

  def active_for_authentication?
    super && active?
  end

  def active?
    status == STATUS_ACTIVE
  end

  def set_plan
    base_plan = Plan.where(default_plan: true).first
    if NowUser.where(:email=>self.email).count > 0
      self.plan_id = 4
    else
      self.plan_id = base_plan.id
    end
  end


  def company
    if companies.length > 0
      companies.at(0)
    else
      nil
    end
  end

  def company_user
    CompanyUser.where(user_id: self.id).first
  end

  def has_access?(company)
    CompanyUser.where(user_id: self.id, company_id: company.id).length > 0
  end

  def is_a_account_admin?
    self.company_users.where(permissions: 1).count > 0
  end

  def destroy
    update_attributes(active: STATUS_DELETED)
  end

  # This gives a list of user_ids which is under the current_user's
  # control by being an account manager.
  def user_ids_can_control
    # This gives the list of company id's where permissions is 1
    company_ids = self.company_users.where(permissions: 1).map(&:company_id)

    # Find me all the user ids that belong to the companies
    user_ids = CompanyUser.where(company_id: company_ids).map(&:user_id)

    # Just to insure the user is seeing all their own videos
    return user_ids.append(self.id)
  end

  private

  def validate_company_token
    if self.company_token
      company = Company.where(company_token: self.company_token)
      if company.length > 0
        CompanyUser.create(user_id: self.id, company_id: company.first.id)
      end
    end
  end

end

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

class UserSerializer < ActiveModel::Serializer

  #cached
  #delegate :cache_key, to: :object

  attributes :email, :id, :used_video_space_seconds, :plan_expiration, :is_company_admin
  has_one :company
  has_one :plan

  def used_video_space_seconds
    object.recordings.sum(:duration)
  end

  def is_company_admin
    object.is_a_account_admin?
  end

end

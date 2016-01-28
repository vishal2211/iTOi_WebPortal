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

class CompanySerializer < ActiveModel::Serializer
  #cached
  #delegate :cache_key, to: :object

  attributes :id,
             :name,
             :whitelabel_icon_url,
             :allow_uploads,
             :whitelabel_text,
             :watermark_image_url,
             :header_image_url,
             :footer_image_url,
             :company_logo_url,
             :simplified_workflow,
             :request_user_email,
             :videos_require_approval,
             :company_token
end

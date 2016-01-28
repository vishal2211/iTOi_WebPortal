FactoryGirl.define do
  factory :company do
    name "Company"
    simplified_workflow false
    request_user_email false
    company_token "abcdef"
  end
end
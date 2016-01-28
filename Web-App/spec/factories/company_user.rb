FactoryGirl.define do
  factory :company_user do
    company
    user
    permissions 0
  end
end
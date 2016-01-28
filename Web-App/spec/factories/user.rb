FactoryGirl.define do
  factory :user do
    password                'password'
    password_confirmation   'password'
    email                   { FactoryGirl.generate :email_address }
    plan_id                 { Plan.first.id }
    plan_expiration         { Date.today + 30.days }
    is_admin                0
    status                  User::STATUS_ACTIVE

    factory :user_with_recordings do
      after(:create) do |user, evaluator|
        (0..5).each do |n|
          create(:recording, created_by: user.id, title: "Recording #{n}")
        end
        company = create(:company)
        create(:company_user, user: user, company: company)
      end
    end

  end
end
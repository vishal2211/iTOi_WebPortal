FactoryGirl.define do
  factory :view_record do
    recording
    view_date Date.today
    view_count 50
  end
end
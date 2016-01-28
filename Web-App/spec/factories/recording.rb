FactoryGirl.define do
  factory :recording do
    created_by 999
    template_id nil
    title "My Recording"
    font_size 40
    expected_length 15.00
    script "My Script"
    scroll_speed 55
    status 0
    video_url nil
    thumbnail_url nil
    duration 15.24
    transcoded_video_url nil
    transcoder_job_id nil
    deleted_at nil

    factory :recording_with_views do
      after(:create) do |rec, evaluator|
        (0..30).each do |n|
          create(:view_record, view_date: (Date.today - n.days), recording_id: rec.id)
        end
      end
    end

  end
end
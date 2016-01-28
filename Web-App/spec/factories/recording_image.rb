FactoryGirl.define do
  factory :recording_image do
    associated_string "Roger"
    sequence :image_url do |n|
      "https://s3.amazonaws.com/iTOi.producer.images/B76F2F80-6B74-4EB5-A953-A734CF4EF86A_#{n}.jpg"
    end
    start_time 5.294
    end_time 7.582
    scroll_height 300
    scroll_y_value 768
  end
end
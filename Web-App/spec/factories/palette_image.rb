FactoryGirl.define do
  factory :palette_image do
  	sequence :image_url do |n|
      "http://www.seeitoi.com/palette_images_#{n}.png"
    end
  end
end
FactoryGirl.define do
  factory :plan do
    name   'Silver'
    max_video_length_seconds '300'
    total_video_space_minutes '100'
    video_filters 5
    can_download true
    video_quality Plan::VIDEO_QUALITY_SD
    youtube_share false
    custom_watermark false
    custom_header_graphic false
    custom_footer_graphic false
    video_analytics false
  end
end
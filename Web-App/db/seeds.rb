# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Plan.create({
    name: 'Bronze',
    default_plan: true,
    max_video_length_seconds: 30,
    total_video_space_minutes: 30,
    video_filters: 5,
    can_download: false,
    video_quality: Plan::VIDEO_QUALITY_HD,
    youtube_share: false,
    custom_watermark: false,
    custom_header_graphic: false,
    custom_footer_graphic: false,
    video_analytics: false
})

Plan.create({
    name: 'Silver',
    default_plan: true,
    max_video_length_seconds: 30,
    total_video_space_minutes: 30,
    video_filters: 5,
    can_download: false,
    video_quality: Plan::VIDEO_QUALITY_HD,
    youtube_share: false,
    custom_watermark: false,
    custom_header_graphic: false,
    custom_footer_graphic: false,
    video_analytics: false
})


Plan.create({
    name: 'Platinum',
    default_plan: true,
    max_video_length_seconds: 30,
    total_video_space_minutes: 30,
    video_filters: 5,
    can_download: false,
    video_quality: Plan::VIDEO_QUALITY_HD,
    youtube_share: false,
    custom_watermark: false,
    custom_header_graphic: false,
    custom_footer_graphic: false,
    video_analytics: false
})

Plan.create({
    name: 'Unlimited',
    default_plan: true,
    max_video_length_seconds: 600,
    total_video_space_minutes: -1,
    video_filters: 5,
    can_download: false,
    video_quality: Plan::VIDEO_QUALITY_HD,
    youtube_share: false,
    custom_watermark: false,
    custom_header_graphic: false,
    custom_footer_graphic: false,
    video_analytics: false
})
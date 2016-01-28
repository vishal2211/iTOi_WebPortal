describe Plan, :type => :model do

  let(:permissions) { {
    max_video_length_seconds: 300,
    total_video_space_minutes: 100,
    video_filters: 5,
    can_download: true,
    video_quality: 'SD',
    youtube_share: false,
    custom_watermark: false,
    custom_header_graphic: false,
    custom_footer_graphic: false,
    video_analytics: false
  } }

  it 'should return the permission hash with video_quality as SD' do
    plan = build(:plan)

    expect(plan.permissions).to eq(permissions)
  end

  it 'should return the permission hash with video_quality as HD' do
    plan = build(:plan, video_quality: 1)

    expected_permissions = permissions.merge(video_quality: 'HD')

    expect(plan.permissions).to eq(expected_permissions)
  end

end
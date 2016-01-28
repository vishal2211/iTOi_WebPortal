class LightRecordingSerializer < ActiveModel::Serializer
  #cached

  def cache_key
    "light-recording/#{object.id}-#{object.updated_at.to_i}"
  end

  attributes :id, :title, :created_at, :expected_length, :duration, :play_url, :play_count, :video_url, :transcoded_video_url, :thumbnail_url, :sharing_approved

  def play_count
    object.view_records.sum(:view_count)
  end




end
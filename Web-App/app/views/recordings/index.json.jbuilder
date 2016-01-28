json.array!(@recordings) do |recording|
  json.extract! recording, :id, :template_id, :created_by, :presentation_template_id, :title
  json.url recording_url(recording, format: :json)
end

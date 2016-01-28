json.array!(@templates) do |template|
  json.extract! template, :id, :created_by, :presentation_template_id, :title, :tag_url, :watermark_url, :left_sidebar_url, :right_sidebar_url
  json.url template_url(template, format: :json)
end

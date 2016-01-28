# == Schema Information
#
# Table name: templates
#
#  id                       :integer          not null, primary key
#  created_by               :integer          not null
#  presentation_template_id :integer
#  title                    :string(255)      not null
#  tag_url                  :string(255)      not null
#  watermark_url            :string(255)      not null
#  left_sidebar_url         :string(255)
#  right_sidebar_url        :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#

class TemplateSerializer < ActiveModel::Serializer

  #cached
  #delegate :cache_key, to: :object

  attributes :id, :created_by, :presentation_template_id, :title, :tag_url, :watermark_url, :left_sidebar_url, :right_sidebar_url
end

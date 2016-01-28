class AddVideoUuid < ActiveRecord::Migration
  def change
    add_column :recordings, :parse_video_uuid, :string
  end
end

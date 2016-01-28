class AddParseFields < ActiveRecord::Migration
  def change
    add_column :users, :parse_id, :string
    add_column :recording_images, :parse_id, :string
    add_column :recordings, :parse_id, :string
  end
end

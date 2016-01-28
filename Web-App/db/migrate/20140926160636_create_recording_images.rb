class CreateRecordingImages < ActiveRecord::Migration
  def change
    create_table :recording_images do |t|
      t.string :associated_string, :null => false
      t.string :image_url, :null => false
      t.decimal :start_time, :null => false, :precision => 10, :scale => 3
      t.decimal :end_time, :null => false, :precision => 10, :scale => 3
      t.integer :scroll_height, :null => false
      t.integer :scroll_y_value, :null => false
      t.integer :recording_id, :null => false

      t.timestamps
    end
  end
end

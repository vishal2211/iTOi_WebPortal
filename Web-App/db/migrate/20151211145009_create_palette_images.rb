class CreatePaletteImages < ActiveRecord::Migration
  def change
    create_table :palette_images do |t|
      t.integer :recording_id
      t.string :image_url
      t.timestamps
    end
  end
end

class AddPaletteImagesToRecording < ActiveRecord::Migration
  def change
    add_column :recordings, :palette_images, :text
  end
end

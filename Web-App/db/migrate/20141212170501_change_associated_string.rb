class ChangeAssociatedString < ActiveRecord::Migration
  def change
    change_column :recording_images, :associated_string, :text
  end
end

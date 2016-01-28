class AddFontSizeToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :font_size, :integer, :null => false, :default => 12
    add_column :recordings, :expected_length, :decimal, :null => false, :precision => 10, :scale => 3
  end
end

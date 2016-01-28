class AddDefaultTitleToRecording < ActiveRecord::Migration
  def change
    change_column :recordings, :title, :string, :default => ""
  end
end

class AddScriptToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :script, :text
  end
end

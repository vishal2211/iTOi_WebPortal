class CreateViewRecords < ActiveRecord::Migration
  def change
    create_table :view_records do |t|
      t.integer :recording_id, :null => false
      t.date :view_date, :null => false
      t.integer :view_count, :null => false, :default => 0

      t.timestamps
    end
  end
end

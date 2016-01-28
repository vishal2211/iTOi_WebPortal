class AddDeletedAtToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :deleted_at, :timestamp
  end
end

class AddSharingApprovedToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :sharing_approved, :boolean, :null => false, :default => 1
  end
end

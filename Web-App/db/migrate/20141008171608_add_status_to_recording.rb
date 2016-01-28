class AddStatusToRecording < ActiveRecord::Migration
  def change
    add_column :recordings, :status, :integer, :null => false, :default => 0
  end
end

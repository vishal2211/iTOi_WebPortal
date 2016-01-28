class RemoveUserEmailFromRecording < ActiveRecord::Migration
  def change
    remove_column :recordings, :user_email, :string
  end
end

class AddRequestUserEmailFields < ActiveRecord::Migration
  def change
    add_column :companies, :request_user_email, :boolean, :null => false, :default => 0
    add_column :recordings, :user_email, :string
  end
end

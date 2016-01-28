class CreateNowUsersApi < ActiveRecord::Migration
  def change
    create_table :now_users_apis do |t|
    	t.string :name, :null=>false
    	t.string :token, :null=>false
    end
    add_index :now_users_apis, [:name, :token], :unique=>true
  end
end

class CreateNowUsers < ActiveRecord::Migration
  def change
    create_table :now_users do |t|
	    t.string  :email, :null=>false, :unique=>true
	    t.string  :account_type, :null=>false
	    t.integer :user_pkg, :default=>0, :null=>false
	    t.integer :company_id, :default=>0, :null=>false
	    t.string  :license, :null=>false
	    t.string  :token, :null=>false
	    t.date 	  :tokenExpiration, :null=>false
	    t.date    :expiration, :null=>false
	    t.string  :purchase_id, :null=>false
	end
	add_index :now_users, [:email, :purchase_id, :license, :token], :unique=>true
  end
end

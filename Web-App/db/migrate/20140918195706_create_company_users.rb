class CreateCompanyUsers < ActiveRecord::Migration
  def change
    create_table :company_users do |t|
      t.integer :user_id, :null => false
      t.integer :company_id, :null => false
      t.integer :permissions, :null => false, :default => 0

      t.timestamps
    end
    add_index :company_users, [:user_id, :company_id], :unique => true
  end
end

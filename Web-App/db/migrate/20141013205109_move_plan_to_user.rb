class MovePlanToUser < ActiveRecord::Migration
  def change
    remove_column :companies, :plan_id
    add_column :users, :plan_id, :integer, :null => false
    add_index :users, :plan_id
  end
end

class AddPermissionsToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :permissions, :text
  end
end

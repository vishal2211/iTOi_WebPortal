class AddPlanExpirationToUser < ActiveRecord::Migration
  def change
    add_column :users, :plan_expiration, :date
  end
end

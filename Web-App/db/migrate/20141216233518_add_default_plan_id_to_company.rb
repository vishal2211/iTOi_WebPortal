class AddDefaultPlanIdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :default_plan_id, :integer
  end
end

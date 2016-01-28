class AddDefaultPlanToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :default_plan, :boolean, :default => false, :null => false
  end
end

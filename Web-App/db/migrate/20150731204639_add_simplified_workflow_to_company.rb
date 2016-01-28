class AddSimplifiedWorkflowToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :simplified_workflow, :boolean, :null => false, :default => false
  end
end

class AddPlanDatesToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :contract_start_date, :date
    add_column :companies, :contract_end_date, :date
  end
end

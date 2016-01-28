class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name, :null => false
      t.integer :plan_id

      t.timestamps
    end
  end
end

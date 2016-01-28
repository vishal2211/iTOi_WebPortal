class CreateCompanyTemplates < ActiveRecord::Migration
  def change
    create_table :company_templates do |t|
      t.integer :template_id, :null => false
      t.integer :company_id, :null => false

      t.timestamps
    end
    add_index :company_templates, [:template_id, :company_id]
  end
end

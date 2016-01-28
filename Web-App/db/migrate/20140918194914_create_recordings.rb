class CreateRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
      t.integer :template_id
      t.integer :created_by, :null => false
      t.integer :presentation_template_id
      t.string :title, :null => false

      t.timestamps
    end
    add_index :recordings, :created_by
  end
end

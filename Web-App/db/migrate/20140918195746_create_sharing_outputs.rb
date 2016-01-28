class CreateSharingOutputs < ActiveRecord::Migration
  def change
    create_table :sharing_outputs do |t|
      t.integer :company_id, :null => false
      t.string :oauth_token, :null => false
      t.integer :output_type, :null => false

      t.timestamps
    end
    add_index :sharing_outputs, :company_id
  end
end

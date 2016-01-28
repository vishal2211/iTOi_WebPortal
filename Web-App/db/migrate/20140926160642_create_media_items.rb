class CreateMediaItems < ActiveRecord::Migration
  def change
    create_table :media_items do |t|
      t.string :name, :null => false
      t.string :media_url, :null => false
      t.integer :company_id, :null => false

      t.timestamps
    end
  end
end

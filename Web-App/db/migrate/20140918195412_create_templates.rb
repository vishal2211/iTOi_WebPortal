class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.integer :created_by, :null => false
      t.integer :presentation_template_id
      t.string :title, :null => false
      t.string :tag_url, :null => false
      t.string :watermark_url, :null => false
      t.string :left_sidebar_url
      t.string :right_sidebar_url

      t.timestamps
    end
    add_index :templates, :created_by
  end
end

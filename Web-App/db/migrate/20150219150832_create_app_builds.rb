class CreateAppBuilds < ActiveRecord::Migration
  def change
    create_table :app_builds do |t|
      t.integer :level, :null => false
      t.string :binary_url, :null => false
      t.integer :version, :null => false

      t.timestamps
    end
  end
end

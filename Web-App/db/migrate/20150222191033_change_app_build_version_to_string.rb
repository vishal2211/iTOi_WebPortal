class ChangeAppBuildVersionToString < ActiveRecord::Migration
  def change
    change_column :app_builds, :version, :string
  end
end

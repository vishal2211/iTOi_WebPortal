class AddVideosRequireApprovalToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :videos_require_approval, :boolean, :null => false, :default => 0
  end
end

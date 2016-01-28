class AddAllowsUploadToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :allow_uploads, :boolean, :null => false, :default => true
    remove_column :plans, :allow_uploads
  end
end

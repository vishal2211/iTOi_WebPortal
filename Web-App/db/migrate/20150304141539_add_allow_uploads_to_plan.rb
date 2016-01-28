class AddAllowUploadsToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :allow_uploads, :boolean, :null => false, :default => 1
  end
end

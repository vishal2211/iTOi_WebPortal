class AddIconToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :whitelabel_icon_url, :string
    add_column :companies, :whitelabel_text, :string
  end
end

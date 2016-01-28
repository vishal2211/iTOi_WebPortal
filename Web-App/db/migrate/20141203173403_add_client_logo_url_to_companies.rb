class AddClientLogoUrlToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :company_logo_url, :string
  end
end

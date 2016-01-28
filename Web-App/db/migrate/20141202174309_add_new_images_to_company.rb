class AddNewImagesToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :header_image_url, :string
    add_column :companies, :footer_image_url, :string
    add_column :companies, :watermark_image_url, :string
  end
end

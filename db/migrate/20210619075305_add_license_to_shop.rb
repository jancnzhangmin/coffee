class AddLicenseToShop < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :license, :string
  end
end

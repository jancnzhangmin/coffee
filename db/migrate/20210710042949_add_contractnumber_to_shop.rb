class AddContractnumberToShop < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :contractnumber, :string
    add_column :shops, :contractstatus, :integer
  end
end

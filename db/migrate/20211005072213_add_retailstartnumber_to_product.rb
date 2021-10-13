class AddRetailstartnumberToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :retailstartnumber, :integer
  end
end

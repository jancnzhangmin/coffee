class AddCoverToShop < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :cover, :string
  end
end

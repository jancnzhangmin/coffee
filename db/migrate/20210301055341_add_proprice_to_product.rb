class AddPropriceToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :proprice, :float
  end
end

class AddPropriceToBuycar < ActiveRecord::Migration[6.0]
  def change
    add_column :buycars, :proprice, :float
  end
end

class AddCostToBuyparamvalue < ActiveRecord::Migration[6.0]
  def change
    add_column :buyparamvalues, :cost, :float
  end
end

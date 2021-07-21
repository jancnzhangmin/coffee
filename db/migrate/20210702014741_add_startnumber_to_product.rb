class AddStartnumberToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :startnumber, :integer
  end
end

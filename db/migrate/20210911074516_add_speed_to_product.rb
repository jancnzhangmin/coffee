class AddSpeedToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :speed, :float
    add_column :products, :quality, :float
    add_column :products, :describe, :float
    add_column :products, :comp, :float
  end
end

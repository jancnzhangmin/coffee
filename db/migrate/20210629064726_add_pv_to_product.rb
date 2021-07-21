class AddPvToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :pv, :integer
  end
end

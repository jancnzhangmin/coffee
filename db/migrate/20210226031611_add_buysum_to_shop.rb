class AddBuysumToShop < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :buysum, :float
    add_column :shops, :lastbuytime, :datetime
  end
end

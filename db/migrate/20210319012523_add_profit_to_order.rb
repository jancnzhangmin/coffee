class AddProfitToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :profit, :float
  end
end

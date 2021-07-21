class RemoveProductidToEvaluate < ActiveRecord::Migration[6.0]
  def change
    remove_column :evaluates, :product_id
  end
end

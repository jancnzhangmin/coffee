class AddSupplieridToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :supplier_id, :bigint
    add_index :products, :supplier_id
  end
end

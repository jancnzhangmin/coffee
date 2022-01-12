class AddSuppliernameToBuyparamvalue < ActiveRecord::Migration[6.0]
  def change
    add_column :buyparamvalues, :suppliername, :string
  end
end

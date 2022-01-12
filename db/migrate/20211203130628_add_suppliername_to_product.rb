class AddSuppliernameToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :suppliername, :string
  end
end

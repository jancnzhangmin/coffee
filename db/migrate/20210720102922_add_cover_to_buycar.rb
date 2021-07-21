class AddCoverToBuycar < ActiveRecord::Migration[6.0]
  def change
    add_column :buycars, :cover, :string
  end
end

class AddNametagToSinglediscount < ActiveRecord::Migration[6.0]
  def change
    add_column :singlediscounts, :nametag, :string
    add_column :singlediscounts, :summary, :string
    add_column :singlediscounts, :cover, :string
    add_column :singlediscounts, :price, :float
  end
end

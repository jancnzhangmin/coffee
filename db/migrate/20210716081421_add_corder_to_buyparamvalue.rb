class AddCorderToBuyparamvalue < ActiveRecord::Migration[6.0]
  def change
    add_column :buyparamvalues, :corder, :bigint
  end
end

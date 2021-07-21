class AddCorderToBuyparam < ActiveRecord::Migration[6.0]
  def change
    add_column :buyparams, :corder, :bigint
  end
end

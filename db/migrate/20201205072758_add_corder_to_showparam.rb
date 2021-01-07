class AddCorderToShowparam < ActiveRecord::Migration[6.0]
  def change
    add_column :showparams, :corder, :bigint
  end
end

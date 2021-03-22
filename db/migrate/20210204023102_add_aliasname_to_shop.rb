class AddAliasnameToShop < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :aliasname, :string
  end
end

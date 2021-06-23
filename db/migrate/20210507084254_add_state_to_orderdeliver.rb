class AddStateToOrderdeliver < ActiveRecord::Migration[6.0]
  def change
    add_column :orderdelivers, :state, :integer
  end
end

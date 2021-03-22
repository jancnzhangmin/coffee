class AddUseridToContract < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :user_id, :bigint
    add_column :contracts, :status, :integer
    add_index :contracts, :user_id
  end
end

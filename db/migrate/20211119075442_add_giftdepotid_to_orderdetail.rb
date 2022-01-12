class AddGiftdepotidToOrderdetail < ActiveRecord::Migration[6.0]
  def change
    add_column :orderdetails, :giftdepot_id, :bigint
  end
end

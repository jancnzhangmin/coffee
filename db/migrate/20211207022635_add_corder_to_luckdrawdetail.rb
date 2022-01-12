class AddCorderToLuckdrawdetail < ActiveRecord::Migration[6.0]
  def change
    add_column :luckdrawdetails, :corder, :bigint
  end
end

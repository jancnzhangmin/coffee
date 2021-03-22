class AddIspublicToProductexplain < ActiveRecord::Migration[6.0]
  def change
    add_column :productexplains, :ispublic, :integer
  end
end

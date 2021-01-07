class AddCorderToBanner < ActiveRecord::Migration[6.0]
  def change
    add_column :banners, :corder, :bigint
  end
end

class CreateJoinTableBannerProduct < ActiveRecord::Migration[6.0]
  def change
    create_join_table :banners, :products do |t|
      # t.index [:banner_id, :product_id]
      # t.index [:product_id, :banner_id]
    end
  end
end

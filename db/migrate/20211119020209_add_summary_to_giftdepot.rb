class AddSummaryToGiftdepot < ActiveRecord::Migration[6.0]
  def change
    add_column :giftdepots, :summary, :string
  end
end

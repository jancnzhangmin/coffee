class AutodeleteshopJob < ApplicationJob
  queue_as :default

  def perform(shopid)
    shop = Shop.find_by(id: shopid)
    if shop && shop.contractstatus.to_i == 0
      shop.destroy
    end
  end
end

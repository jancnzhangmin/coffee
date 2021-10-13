class Api::ActivelistsController < ApplicationController
  def index
    buyfullactives = Buyfullactive.where('begintime <= ? and endtime >= ? and status = ?', Time.now, Time.now, 1)
    activeproductarr = []
    buyfullactives.each do |buyfullactive|
      product = Product.find(buyfullactive.product_id)
      buyfullactive_param = {
          id: product.id,
          img: buyfullactive.cover,
          name: buyfullactive.name,
          price: buyfullactive.price
      }
      activeproductarr.push buyfullactive_param
    end
    activeproductarr.push 1
    activeproductarr.push 2
    return_api(activeproductarr)
  end
end

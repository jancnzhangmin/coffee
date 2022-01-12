class Api::ActivelistsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    activeproductarr = []
    buyfullactives = Buyfullactive.where('begintime <= ? and endtime >= ? and status = ?', Time.now, Time.now, 1)
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

    singlediscounts = Singlediscount.where('begintime <= ? and endtime >= ? and status = ?', Time.now, Time.now, 1)
    singlediscounts.each do |singlediscount|
      product = Product.find(singlediscount.product_id)
      singlediscount_param = {
          id: product.id,
          img: singlediscount.cover,
          name: singlediscount.name,
          price: singlediscount.price
      }
      if singlediscount.limitnewpeople.to_i == 1 && user.created_at > singlediscount.newpeopletime
        activeproductarr.push singlediscount_param
      elsif singlediscount.limitnewpeople.to_i == 0
        activeproductarr.push singlediscount_param
      end
    end
    total = activeproductarr.size
    if activeproductarr.size < 3
      (3 - activeproductarr.size).times do |i|
        activeproductarr.push i + 1
      end
    end
    param = {
        total: total,
        data: activeproductarr
    }
    return_api(param)
  end
end

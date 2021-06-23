class Api::ShopoverviewsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    shopids = user.shopusers.where(member:[1,2]).map(&:shop_id)
    orders = Order.where(shop_id: shopids, paystatus: 1)
    ordercount = orders.size
    ordersum = orders.sum('amount').to_s(:currency, unit:'￥')
    param = {
        ordercount: ordercount,
        ordersum: ordersum
    }
    return_api(param)
  end
end

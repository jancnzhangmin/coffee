class Api::ShopordersController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    shopids = user.shopusers.where(member:[1,2]).map(&:shop_id)
    orders = Order.where(shop_id: shopids, paystatus: 1).order('id desc').page(params[:page]).per(10)
    final = 0
    final = 1 if orders.last_page? || orders.out_of_range?
    orderarr = []
    orders.each do |f|
      shopname = ''
      shop = Shop.find_by(id: f.shop_id)
      if shop
        shopname = shop.name
        shopname = shop.aliasname if shop.aliasname.to_s.size > 0
      end
      order_param = {
          id: f.id,
          ordernumber: f.ordernumber,
          amount: f.amount.to_f.to_s(:currency, unit:'￥'),
          shop: shopname,
          paytime: f.paytime.strftime('%Y-%m-%d %H:%M:%S')
      }
      orderarr.push order_param
    end
    param = {
        data: orderarr,
        final: final
    }
    return_api(param)
  end
end

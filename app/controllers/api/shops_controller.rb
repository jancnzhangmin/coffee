class Api::ShopsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    shopusers = user.shopusers.where('member <> 0')
    shops = Shop.where(id: shopusers.map(&:shop_id)).order('id desc')
    shoparr = []
    shops.each do |f|
      name = f.name.to_s
      name = f.aliasname.to_s if f.aliasname.to_s.size > 0
      issetting = '未设置店铺'
      issetting = '' if f.lng.to_f != 0
      shop_param = {
          id: f.id,
          name: name,
          lng: f.lng.to_f,
          lat: f.lat.to_f,
          province: f.province.to_s,
          city: f.city.to_s,
          district: f.district.to_s,
          address: f.address.to_s,
          adcode: f.adcode.to_s,
          issetting: issetting
      }
      shoparr.push shop_param
    end
    return_api(shoparr)
  end
end

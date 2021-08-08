class Api::ShoplistController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    shops = Shop.where(contractstatus: 1).order('created_at desc')
    if user.lng
      #shops = shops.where('adcode like ?', params[:adcode][0,4] + "__")
      shops = Shop.where(contractstatus: 1)
    shops = shops.by_distance(:origin=>user)
    end
    shops = shops.page(params[:page]).per(10)
    final = 0
    final = 1 if shops.last_page? || shops.out_of_range?
    larr = []
    rarr = []
    shops.each_with_index  do |f, index|
      name = f.name
      name = f.aliasname if f.aliasname.to_s.size > 0
      distance = user.distance_to(f)
      distancestr = distance.round(0).to_s + '米' if distance < 1000
      distancestr = (distance / 1000).round(1).to_s + '公里' if distance >= 1000
      distancestr = '距您直线距离' + distancestr
      if !user.lng
        distancestr = '无可用距离'
      end
      shop_param = {
          id: f.id,
          name: name,
          cover: f.cover,
          distance: distancestr,
      }
      if index % 2 == 0
        larr.push shop_param
      else
        rarr.push shop_param
      end
    end
    param = {
        final: final,
        data: [larr, rarr]
    }
    return_api(param)
  end
end

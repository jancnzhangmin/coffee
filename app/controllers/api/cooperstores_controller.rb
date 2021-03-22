class Api::CooperstoresController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    shopusers = user.shopusers.where('member in (?)', [0,1])
    shops = Shop.where('id in (?)', shopusers.map(&:shop_id) + [0])
    corder = 'asc'
    corder = 'desc' if params[:ordervalue].to_i == 2
    shops = shops.where('name like ? or aliasname like ?',"%#{params[:searchkey]}%", "%#{params[:searchkey]}%")
    if params[:ordertype] == 'signedtime'
      shops = shops.order("created_at #{corder}")
    elsif params[:ordertype] == 'buy'
      shops = shops.order("buysum #{corder}")
    elsif params[:ordertype] == 'nearbuy'
      shops = shops.order("lastbuytime #{corder}")
    elsif params[:ordertype] == 'distance'
      if params[:ordervalue].to_i == 2
        shops = shops.by_distance(:origin=>user, :reverse => true)
      else
        shops = shops.by_distance(:origin=>user)
      end
    end
    shops = shops.page(params[:page]).per(10)
    final = 0
    final = 1 if shops.last_page? || shops.out_of_range?
    shoparr = []
    shops.each do |f|
      distance = user.distance_to(f)
      distancestr = distance.round(0).to_s + 'm' if distance < 1000
      distancestr = (distance / 1000).round(1).to_s + 'km' if distance >= 1000
      distancestr = '无可用位置' if user.lng.to_i == 0 || f.lng.to_i == 0
      lastbuytime = '未采购'
      lastbuytime = f.lastbuytime.strftime('%Y-%m-%d') if f.lastbuytime
      director = '未设置'
      directors = f.shopusers.where('member = ?', 1).first
      if directors
        director = directors.user.nickname.to_s
      end
      shop_param = {
          id: f.id,
          firstname: f.name[0],
          name: f.name,
          distance: distancestr,
          signedtime: f.created_at.strftime('%Y-%m-%d'),
          province: f.province.to_s,
          city: f.city.to_s,
          district: f.district.to_s,
          address: f.address.to_s,
          buysum: ActiveSupport::NumberHelper.number_to_currency(f.buysum.to_f,unit:''),
          lastbuytime: lastbuytime,
          director: director
      }
      shoparr.push shop_param
    end
    param = {
        final: final,
        data: shoparr
    }
    return_api(param)
  end
end

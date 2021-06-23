class Api::CooperstoredetailsController < ApplicationController
  def index
    shop = Shop.find(params[:shop_id])
    user = User.find_by_token(params[:token])
    director = '未设置'
    shopuser = shop.shopusers.where('member = ?', 1).first
    if shopuser
      director = shopuser.user.nickname
    end
    lastbuytime = '未采购'
    lastbuytime = shop.lastbuytime.strftime('%Y-%m-%d') if shop.lastbuytime
    province = '未设置店铺地址'
    province = shop.province.to_s if shop.province.to_s.size > 0
    lat = user.lat.to_f
    lat = shop.lat.to_f if shop.lat.to_f != 0
    lng = user.lng.to_f
    lng = shop.lng.to_f if shop.lng.to_f != 0
    hasadd = 0
    hasadd = 1 if shop.lng.to_f != 0
    shop_param = {
        id: shop.id,
        director: director,
        buysum: ActiveSupport::NumberHelper.number_to_currency(shop.buysum.to_f,unit:''),
        lastbuytime: lastbuytime,
        province: province,
        city: shop.city.to_s,
        district: shop.district.to_s,
        address: shop.address.to_s,
        lat: lat,
        lng: lng,
        hasadd: hasadd
    }
    return_api(shop_param)
  end

  def getdirectorlist
    shop = Shop.find(params[:shop_id])
    shopusers = shop.shopusers
    users = User.where('id not in (?) and nickname like ?', shopusers.map(&:user_id) + [0], "%#{params[:searchkey]}%").order('created_at desc').page(params[:page]).per(10)
    final = 0
    final = 1 if users.last_page? || users.out_of_range?
    ischecked = 0
    userarr = []
    shopusers.each do |f|
      user = f.user
      checked = false
      checked = true if f.member.to_i == 1
      if f.member.to_i == 1
        ischecked = 1
      end
      user_param = {
          id: user.id,
          title: user.nickname.to_s,
          img: user.headurl.to_s,
          checked: checked
      }
      if params[:page].to_i == 1
      userarr.push user_param
      end
    end

    users.each do |f|
      user_param = {
          id: f.id,
          title: f.nickname.to_s,
          img: f.headurl.to_s,
          checked: false
      }
      userarr.push user_param
    end
    param = {
        final: final,
        data: userarr,
        ischecked: ischecked
    }
    return_api(param)
  end

  def setdirector
    shop = Shop.find(params[:shop_id])
    user = User.find_by_token(params[:token])
    shopusers = shop.shopusers
    shopusers.each do |f|
      if f.member.to_i == 1
        f.update(member: 2)
      end
      if f.user_id == user.id
        f.update(member: 0)
      end
    end
    if shopusers.map(&:user_id).include?(params[:user_id].to_i)
      shopuser = shopusers.where('user_id = ?', params[:user_id]).first
      shopuser.update(member: 1)
    else
      shop.shopusers.create(user_id: params[:user_id], member: 1)
    end
    return_api('')
  end
end

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
      isdefault = 0
      isdefault = 1 if user.shopdefaultid.to_i == f.id
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
          issetting: issetting,
          isdefault: isdefault
      }
      shoparr.push shop_param
    end
    return_api(shoparr)
  end

  def getcurrentshop
    user = User.find_by_token(params[:token])
    shopusers = user.shopusers.where('member <> 0')
    currentshop = {
        id: 0,
        name: "",
        lng: 0,
        lat: 0,
        province: "",
        city: "",
        district: "",
        address: "",
        adcode: "",
        issetting: '未设置店铺'
    }
    if user.shopdefaultid.to_i == 0
      currentshops = Shop.where(id: shopusers.map(&:shopid))
      issetting = '未设置店铺'
      if currentshops.first
      issetting = '' if currentshops.first.lng.to_f != 0
      currentshop[:id] = currentshops.first.id
      currentshop[:name] = currentshops.first.name
      currentshop[:lng] = currentshops.first.lng.to_f
      currentshop[:lat] = currentshops.first.lat.to_f
      currentshop[:province] = currentshops.first.province.to_s
      currentshop[:city] = currentshops.first.city.to_s
      currentshop[:district] = currentshops.first.district.to_s
      currentshop[:address] = currentshops.first.address.to_s
      currentshop[:adcode] = currentshops.first.adcode
      currentshop[:issetting] = issetting
      end
    else
      currentshops = Shop.find_by(id: user.shopdefaultid)
      if currentshops
      issetting = '未设置店铺'
      issetting = '' if currentshops.lng.to_f != 0
      currentshop[:id] = currentshops.id
      currentshop[:name] = currentshops.name
      currentshop[:lng] = currentshops.lng.to_f
      currentshop[:lat] = currentshops.lat.to_f
      currentshop[:province] = currentshops.province.to_s
      currentshop[:city] = currentshops.city.to_s
      currentshop[:district] = currentshops.district.to_s
      currentshop[:address] = currentshops.address.to_s
      currentshop[:adcode] = currentshops.adcode
      currentshop[:issetting] = issetting
      end
    end
    return_api(currentshop)
  end

  def setdefault
    user = User.find_by_token(params[:token])
    user.update(shopdefaultid: params[:shopid])
    return_api('')
  end

  def getshopaddress
    user = User.find_by_token(params[:token])
    shop = Shop.find(params[:shop_id])
    lat = shop.lat.to_f
    lng = shop.lng.to_f
    if lat == 0
      lat = user.lat
      lng = user.lng
    end
    if lat == 0
      lat = 24.350996000000
      lng = 102.553793000000
    end
    if params[:lat].to_f != 0
      lat = params[:lat]
      lng = params[:lng]
    end
    param = {
        lat: lat,
        lng: lng,
        address: shop.address.to_s,
        near: get_amb(lat, lng)
    }
    return_api(param)
  end

  def setshopaddress
    shop = Shop.find(params[:shop_id])
    adcoderes = get_area(params[:lat], params[:lng])
    adcode = adcoderes["result"]["addressComponent"]["adcode"]
    province = adcoderes["result"]["addressComponent"]["province"]
    city = adcoderes["result"]["addressComponent"]["city"]
    district = adcoderes["result"]["addressComponent"]["district"]
    shop.update(lat: params[:lat], lng: params[:lng], province: province, city: city, district: district, address: params[:address], adcode: adcode)
    return_api('')
  end

  private

  def get_amb(lat, lng)
    conn = Faraday.new(:url => 'http://api.map.baidu.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:query] = '酒店'
    conn.params[:location] = lat.to_s + ',' + lng.to_s
    conn.params[:radius] = 1000
    conn.params[:coordtype] = 'wgs84ll'
    conn.params[:output] = 'json'
    conn.params[:scope] = '2'
    conn.params[:filter] = 'sort_name:distance|sort_rule:1'
    conn.params[:ak] = '9XW0meqlCG0LXuTpjW5Pv9I4H9qMCgWr'
    request = conn.post do |req|
      req.url '/place/v2/search'
    end
    JSON.parse(request.body)["results"]
  end

  def get_area(lat, lng)
    conn = Faraday.new(:url => 'http://api.map.baidu.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:ak] = '9XW0meqlCG0LXuTpjW5Pv9I4H9qMCgWr'
    conn.params[:output] = 'json'
    conn.params[:coordtype] = 'wgs84ll'
    conn.params[:location] = lat.to_s + ',' + lng.to_s
    request = conn.post do |req|
      req.url 'reverse_geocoding/v3/'
    end
    JSON.parse(request.body)
  end
end

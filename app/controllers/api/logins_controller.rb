class Api::LoginsController < ApplicationController
  def create
    status = 10000
    token = ''
    conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:appid] = Setting.first.appid
    conn.params[:secret] = Setting.first.appsecret.to_s
    conn.params[:js_code] = params[:code]
    conn.params[:grant_type] = 'authorization_code'
    request = conn.post do |req|
      req.url '/sns/jscode2session'
    end
    data = JSON.parse(request.body)
    if data["errcode"] && data["errcode"] != 0
      status = 10001
    else
      user = User.find_by_openid(data["openid"])
      if user
        user.update(unionid: data["unionid"])
      else
        user = User.create(openid: data["openid"], unionid: data["unionid"])
        Backrun.newpeople_invitationgift(user.id)
        Backrun.gift_luckdraw_times(user.id)
      end
      examine = user.examines.last
      if !examine
        agentlevel = Agentlevel.find_by_businetype('man')
        user.examines.create(agentlevel_id: agentlevel.id, checkexamine: 0)
      end
      token = user.token
    end
    param = {
        token: token
    }
    return_api(param,status)
  end

  def updateinfo
    user = User.find_by_token(params[:token])
    user.update(nickname: params[:userinfo][:nickName], headurl:params[:userinfo][:avatarUrl])
    return_res('')
  end

  def setlocation
    user = User.find_by_token(params[:token])
    user.update(lng: params[:lng], lat: params[:lat])
    location = getadcode(user.lat, user.lng)
    return_api(location)
  end

  private

  def getadcode(lat,lng)
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

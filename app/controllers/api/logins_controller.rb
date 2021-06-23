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
      else
        user = User.create(openid: data["openid"])
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
    return_api('')
  end
end

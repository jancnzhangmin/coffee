class Api::PostersController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    product = Product.find(params[:product_id])
    posters = product.posters
    posterarr = []
    posters.each do |f|
      if f.content.to_s.size > 0
        posterarr.push JSON.parse(f.content)
      end
    end
    param = {
        userid: user.id,
        posters: posterarr
    }
    return_api(param)
  end

  def getwxacodeunlimit
    user = User.find_by_token(params[:token])
    conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:access_token] = Backrun.get_accesstoken
    request = conn.post do |req|
      req.url '/wxa/getwxacodeunlimit'
      req.headers['Content-Type'] = 'application/json'
      req.body = {scene:"uid=#{user.id}&pid=#{params[:product_id]}"}.to_json.gsub(/\\u([0-9a-z]{4})/){|s| [$1.to_i(16)].pack("U")}
    end
    if  request.body.include?("errcode")
      conn.params[:access_token] = Backrun.refresh_accesstoken
      request = conn.post do |req|
        req.url '/wxa/getwxacodeunlimit'
        req.headers['Content-Type'] = 'application/json'
        req.body = {scene:"uid=#{user.id}&pid=#{params[:product_id]}"}.to_json.gsub(/\\u([0-9a-z]{4})/){|s| [$1.to_i(16)].pack("U")}
      end
    end
    data = 'data:image/jpg;base64,' + Base64.encode64(request.body)
    return_api(data)
  end

  private


end

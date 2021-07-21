class Api::CoopersignController < ApplicationController
  def createcode
    contract = Contract.find(params[:contract_id])
    shop = contract.shop
    conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:access_token] = Backrun.get_accesstoken
    request = conn.post do |req|
      req.url '/wxa/getwxacodeunlimit'
      req.headers['Content-Type'] = 'application/json'
      req.body = {scene:"signid=#{shop.id}"}.to_json.gsub(/\\u([0-9a-z]{4})/){|s| [$1.to_i(16)].pack("U")}
    end
    if  request.body.include?("errcode")
      conn.params[:access_token] = Backrun.refresh_accesstoken
      request = conn.post do |req|
        req.url '/wxa/getwxacodeunlimit'
        req.headers['Content-Type'] = 'application/json'
        req.body = {scene:"signid=#{shop.id}"}.to_json.gsub(/\\u([0-9a-z]{4})/){|s| [$1.to_i(16)].pack("U")}
      end
    end
    data = 'data:image/jpg;base64,' + Base64.encode64(request.body)
    param = {
        data: data,
        shopname: shop.name
    }
    return_api(param)
  end

  def contractpreview
    shop = Shop.find_by(id: params[:shop_id])
    status = 10000
    errMsg = ''
    isparent = false
    contracts = ''
    if shop
      shopusers = shop.shopusers.where(member: 1)
      user = shop.shopusers.where(member: 0).first.user
      userparent = user.parent
      adminuser = User.find_by_token(params[:token])
      while userparent do
        if adminuser.id == userparent.id
          isparent = true
          break
        else
          userparent = userparent.parent
        end
      end
    end

    if isparent
      status = 10001
      errMsg = '您属于发起签约业务员的上级，不能签约'
    else
      if !shop
        status = 10001
        errMsg = '约签码已失效'
      elsif shop.contractstatus.to_i == 1
        status = 10001
        errMsg = '约签码已失效'
      elsif shopusers.size > 0
        status = 10001
        errMsg = '约签码已失效'
      else
        contracts = shop.contracts.first.contractdetails.map(&:contractimg)
      end
    end
    return_api(contracts, status, errMsg)
  end

  def createsign
    Gencontract.createsign(params[:img], params[:shop_id])
    adminuser = User.find_by_token(params[:token])
    shop = Shop.find(params[:shop_id])
    user = shop.shopusers.where(member: 0).first.user
    if adminuser.id != user.id
      adminuser.update(up_id: user.id)
    end
    shop.shopusers.create(user_id: adminuser.id, member: 1)
    shop.update(contractstatus: 1)
    shop.contracts.first.update(status: 1)
    return_api('')
  end


end

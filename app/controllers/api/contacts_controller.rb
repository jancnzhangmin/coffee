class Api::ContactsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    shops = Shop.where('name like ?', "%#{params[:searchkey]}%")
    shopids = shops.ids + [0]
    contracts = user.contracts.where('shop_id in (?)',shopids).order('id desc').page(params[:page]).per(10)
    final = 0
    final = 1 if contracts.last_page? || contracts.out_of_range?
    contractarr = []
    contracts.each do |f|
      contract_param = {
          id: f.id,
          firstname: f.shop.name[0],
          name:f.shop.name,
          imgs: f.contractdetails.map(&:contractimg)
      }
      contractarr.push contract_param
    end
    param = {
        final: final,
        data: contractarr
    }
    return_api(param)
  end

  def create
    user = User.find_by_token(params[:token])
    shopuser = user.shopusers.create(member: 0)
    shop = Shop.create(name: params[:name], license: params[:license])
    shopuser.update(shop_id: shop.id)
    contractdom = shop.contracts.create(user_id: user.id, status: 1)
    params[:imgs].each do |f|
      contractdom.contractdetails.create(contractimg: f)
    end
    return_api('')
  end

  def checkrepeat
    status = 10000
    msg = ''
    shop = Shop.find_by_license(params[:license].lstrip.rstrip.upcase)
    if shop
      status = 10001
      msg = '统一社会信用代码已存在'
    end
    return_api('', status, msg)
  end
end

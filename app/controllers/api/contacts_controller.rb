class Api::ContactsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    shops = Shop.where('name like ? and contractstatus = ?', "%#{params[:searchkey]}%", 1)
    shopdrafts = Shop.where('created_at > ? and contractstatus = ?', Time.now - 1.days, 0)
    shopids = shops.ids + shopdrafts.ids + [0]

    contracts = user.contracts.where('shop_id in (?)',shopids)
    contracts = contracts.order('id desc').page(params[:page]).per(10)
    final = 0
    final = 1 if contracts.last_page? || contracts.out_of_range?
    contractarr = []
    contracts.each do |f|
      if f.shop.created_at > Time.now - 23.hours
        delete_time = ((f.shop.created_at + 1.days - Time.now) / 60 / 60).to_i.to_s + '小时后删除'
      else
        delete_time = ((f.shop.created_at + 1.days - Time.now) / 60).to_i.to_s + '分钟后删除'
      end

      contract_param = {
          id: f.id,
          firstname: f.shop.name[0],
          name:f.shop.name,
          imgs: f.contractdetails.map(&:contractimg),
          contractstatus: f.shop.contractstatus.to_i,
          delete_time: delete_time
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
    contractnumber = 'MS' + Time.now.strftime('%Y%m%d')
    his_shop = Shop.where('created_at between ? and ?', Time.now.beginning_of_day, Time.now).last
    if his_shop
      contractnumber += (his_shop.contractnumber[-3, 3].to_i + 1).to_s.rjust(3, '0')
    else
      contractnumber += 1.to_s.rjust(3, '0')
    end
    shop = Shop.create(name: params[:name], license: params[:license], province: params[:province], city: params[:city], district: params[:district], address: params[:address], adcode: params[:adcode], contractnumber: contractnumber, contractstatus: 0)
    coor = get_coordinate(params[:province].to_s + params[:city].to_s + params[:district].to_s + params[:address].to_s)
    begin
      shop.update(lng: coor["result"]["location"]["lng"], lat: coor["result"]["location"]["lat"])
    rescue

    end
    shopuser.update(shop_id: shop.id)
    Gencontract.contractdraft(shop.id, contractnumber, user.id, 'new', params[:name], params[:province] + params[:city] + params[:district] + params[:address])
    AutodeleteshopJob.set(wait: 25.hours).perform_later(shop.id)
    return_api('')
  end

  def handwritten
    shopuser = User.find_by_token(params[:token])
    
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

  def deletecontract
    contract = Contract.find_by(id: params[:contract_id])
    if contract
      shop = contract.shop
      if shop.contractstatus.to_i == 0
        shop.destroy
      end
    end
    return_api('')
  end

  private

  def get_coordinate(address)
    conn = Faraday.new(:url => 'http://api.map.baidu.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:address] = address
    conn.params[:ak] = '9XW0meqlCG0LXuTpjW5Pv9I4H9qMCgWr'
    conn.params[:output] = 'json'
    conn.params[:ret_coordtype] = 'WGS84'
    request = conn.post do |req|
      req.url '/geocoding/v3/'
    end
    JSON.parse(request.body)
  end
end

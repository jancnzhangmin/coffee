class Admin::ShopsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      shops = Shop.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      shops = Shop.all.order('id desc')
    end
    total = shops.size
    shops = shops.page(params[:page]).per(params[:per])
    shoparr = []
    shops.each do |f|
      shopadmin = f.shopusers.where(member: 1).first
      shopadminname = ''
      if shopadmin
        shopadminuser = shopadmin.user
        shopadminname = shopadminuser.openid.to_s if shopadminuser
        shopadminname = shopadminuser.nickname.to_s if shopadminuser && shopadminuser.nickname.to_s.size > 0
      end
      shopusername = ''
      shopuser = f.shopusers.where(member: 0).first
      if shopuser
        shopusername = shopuser.user.openid
        shopusername = shopuser.user.nickname.to_s if shopuser.user.nickname.to_s.size > 0
      end
      lastbuytime = ''
      lastbuytime = f.lastbuytime.strftime('%Y-%m-%d %H:%M:%S') if f.lastbuytime
      shop_param = {
          id: f.id,
          name: f.name,
          address: f.province.to_s + f.city.to_s + f.district.to_s + f.address.to_s,
          created_at: f.created_at.strftime('%Y-%m-%d %H:%M:%S'),
          lastbuytime: lastbuytime,
          buysum: f.buysum.to_f.to_s(:currency, unit:''),
          shopadminname: shopadminname,
          shopusername: shopusername,
          contractstatus: f.contractstatus.to_i
      }
      shoparr.push shop_param
    end
    param = {
        data: shoparr,
        total: total,
    }
    return_res(param)
  end

  def destroy
    shop = Shop.find(params[:id])
    shop.destroy
    return_res('')
  end

  def getcover
    shop = Shop.find(params[:id])
    return_res(shop.cover)
  end

  def setcover
    shop = Shop.find(params[:id])
    resource = Resource.find_by_resourceurl(shop.cover)
    if resource && resource.resourceurl.to_s.size > 0
      resource.destroy
    end
    resource = Resource.create(resource: params[:file])
    shop.update(cover: Rails.configuration.serverurl + resource.resource.url)
    return_res(shop.cover)
  end
end

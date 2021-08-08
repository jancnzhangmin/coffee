class Api::ShopsettinglistController < ApplicationController
  def index
    shop = Shop.find(params[:shop_id])
    name = shop.name
    name = shop.aliasname if shop.aliasname.to_s.size > 0
    param = {
        cover: shop.cover,
        name: name
    }
    return_api(param)
  end

  def getcover
    shop = Shop.find(params[:shop_id])
    param = {
        cover: shop.cover
    }
    return_api(param)
  end

  def setcover
    shop = Shop.find(params[:shop_id])
    resource = Resource.find_by_resourceurl(shop.cover)
    resource.destroy if resource && shop.cover.to_s.size > 0
    shop.update(cover: params[:cover])
    return_api('')
  end

  def getname
    shop = Shop.find(params[:shop_id])
    name = shop.name
    name = shop.aliasname if shop.aliasname.to_s.size > 0
    param = {
        name: name
    }
    return_api(param)
  end

  def setname
    shop = Shop.find(params[:shop_id])
    shop.update(aliasname: params[:name])
    return_api('')
  end
end

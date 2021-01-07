class Api::HomesController < ApplicationController
  def getswiper
    banners = Banner.all.order('corder')
    bannerarr = []
    banners.each do |f|
      banner_param = {
          id: f.id,
          banner: f.banner
      }
      bannerarr.push banner_param
    end
    param = {
        banners: bannerarr
    }
    return_api(param)
  end

  def getproductlist
    products = Product.all
    productarr = []
    products.each do |f|
      product_param = {
          id: f.id,
          name: f.name,
          subname: f.subname,
          price: f.price,
          cover: f.cover.to_s
      }
      productarr.push product_param
    end
    param = {
        products: productarr
    }
    return_api(param)
  end
end

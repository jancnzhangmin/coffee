class Api::HomesController < ApplicationController
  def getswiper
    banners = Banner.all.order('corder')
    bannerarr = []
    banners.each do |f|
      banner_param = {
          img: f.banner,
          url: '',
          title: '',
          opentype: 'navigate'
      }
      bannerarr.push banner_param
    end
    param = {
        banners: bannerarr
    }
    return_api(param)
  end

  def getproductlist
    products = Product.where('onsale = ?', 1)
    productarr = []
    products.each do |f|
      product_param = {
          id: f.id,
          name: f.name,
          subname: f.subname,
          price: f.price,
          img: f.cover.to_s
      }
      productarr.push product_param
    end
    param = {
        products: productarr
    }
    return_api(param)
  end
end

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
    user = User.find_by_token(params[:token])
    products = Product.where('onsale = ?', 1)
    productarr = []
    products.each do |f|
      price = f.price
      shopusers = user.shopusers.where('member <> ?', 0)
      price = f.proprice.to_f if shopusers.size > 0 && f.proprice.to_f > 0
      product_param = {
          id: f.id,
          name: f.name,
          subname: f.subname,
          price: price,
          img: f.cover.to_s,
          priceMarket: f.price
      }
      productarr.push product_param
    end
    param = {
        products: productarr
    }
    return_api(param)
  end
end

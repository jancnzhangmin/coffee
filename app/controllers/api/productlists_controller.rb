class Api::ProductlistsController < ApplicationController
  def getproductclas
    productclas = Productcla.all.order('corder')
    productclaarr = []
    productclas.each do |f|
      productcla_param = {
          id: f.id,
          name: f.name,
          number: 0
      }
      productclaarr.push productcla_param
    end
    return_api(productclaarr)
  end

  def getproductlists
    user = User.find_by_token(params[:token])
    productcla = Productcla.find(params[:productcla_id])
    products = productcla.products.where('onsale = ?', 1)
    productarr = []
    products.each do |f|
      price = f.price
      shopusers = user.shopusers.where('member <> ?', 0)
      price = f.proprice.to_f if shopusers.size > 0 && f.proprice.to_f > 0
      product_param = {
          id: f.id,
          name: f.name,
          price: price,
          cover: f.cover,
          number: 0,
          priceMarket: f.price
      }
      productarr.push product_param
    end
    return_api(productarr)
  end
end

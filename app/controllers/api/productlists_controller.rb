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
    productcla = Productcla.find(params[:productcla_id])
    products = productcla.products.where('onsale = ?', 1)
    productarr = []
    products.each do |f|
      product_param = {
          id: f.id,
          name: f.name,
          price: f.price,
          cover: f.cover,
          number: 0
      }
      productarr.push product_param
    end
    return_api(productarr)
  end
end

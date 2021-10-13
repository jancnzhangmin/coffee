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
      buyparamarr = []
      buyparams = f.buyparams.order('corder')
      buyparams.each do |buyparam|
        buyparamvaluearr = []
        buyparamtagarr = []
        buyparamvalues = buyparam.buyparamvalues.order('corder')
        buyparamvalues.each do |buyparamvalue|
          buyparamvalue_param = {
              buyparamvalue_id: buyparamvalue.id,
              name: buyparamvalue.name,
              cover: buyparamvalue.cover,
              cost: buyparamvalue.cost.to_f,
              price: buyparamvalue.price.to_f,
              checked: false
          }
          buyparamtag_param = {
              id: buyparamvalue.id,
              text: buyparamvalue.name,
              checked: false,
          }
          buyparamtagarr.push buyparamtag_param
          buyparamvaluearr.push buyparamvalue_param
        end
        buyparam_param = {
            buyparam_id: buyparam.id,
            param: buyparam.param,
            buyparamvalues: buyparamvaluearr,
            buyparamtags: buyparamtagarr
        }
        buyparamarr.push buyparam_param
      end
      startnumber = f.retailstartnumber.to_i
      startnumber = f.startnumber if shopusers.size > 0
      buyfullactives = Buyfullactive.where('begintime <= ? and endtime >= ? and status = ? and product_id = ?', Time.now, Time.now, 1, f.id)
      activetag = buyfullactives.map(&:nametag)
      product_param = {
          id: f.id,
          name: f.name,
          price: price,
          cover: f.cover,
          number: 0,
          priceMarket: f.price,
          startnumber: startnumber,
          buyparams: buyparamarr,
          proprice: f.proprice.to_f,
          activetag: activetag
      }
      productarr.push product_param
    end
    return_api(productarr)
  end
end

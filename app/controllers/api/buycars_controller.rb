class Api::BuycarsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    buycars = getbuycars(user.id,params[:shoudan].to_i, params[:chooseproprice].to_i, params[:shopid].to_i)
    return_api(buycars)
  end

  def create
    user = User.find_by_token(params[:token])
    buycars = user.buycars
    product_id = params[:datas][2][0].to_i
    number = params[:datas][0].to_i
    if number <= 0
      buycar = buycars.where('product_id = ?', product_id).first
      buycar.destroy
    else
      product = Product.find(product_id)
      buycar = buycars.where('product_id = ?', product_id).first
      proprice = product.price
      shopusers = user.shopusers.where('member <> ?', 0)
      proprice = product.proprice if product.proprice.to_f > 0 && shopusers.size > 0
      if buycar
        buycar.update(number: number, price: product.price, proprice: proprice)
      else
        user.buycars.create(number: number, product_id: product_id, price: product.price, proprice: proprice, producttype: 0)
      end
    end
    buycararr = getbuycars(user.id,params[:shoudan].to_i, params[:chooseproprice].to_i, params[:shopid].to_i)
    return_api(buycararr)
  end

  private
  def getbuycars(userid, shoudan, chooseproprice, shopid)

    user = User.find(userid)
    buycars = user.buycars.where(producttype: 1)
    buycars.destroy_all
    Backrun.cal_shoudan(userid, shoudan, chooseproprice, shopid)
    buycars = user.buycars
    buycararr = []
    paysum = 0
    propricesum = 0
    buycars.each do |f|
      product = f.product
      buycar_param = {
          id: f.id,
          number: f.number,
          price: f.price,
          product_id: product.id,
          name: product.name,
          cover: product.cover,
          productcla_ids: product.productclas.ids,
          proprice: f.proprice,
          producttype: f.producttype.to_i,
          activesummary: f.activesummary.to_s
      }
      paysum += f.number.to_f * f.price.to_f
      propricesum += f.number.to_f * f.proprice.to_f
      buycararr.push buycar_param
    end
    param = {
        buycars: buycararr,
        paysum: paysum.round(2),
        propricesum: propricesum.round(2)
    }
    param
  end
end

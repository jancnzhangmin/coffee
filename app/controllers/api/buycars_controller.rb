class Api::BuycarsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    buycars = getbuycars(user.id)
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
      if buycar
        buycar.update(number: number, price: product.price)
      else
        user.buycars.create(number: number, product_id: product_id, price: product.price)
      end
    end
    buycararr = getbuycars(user.id)
    return_api(buycararr)
  end

  private
  def getbuycars(userid)
    user = User.find(userid)
    buycars = user.buycars
    buycararr = []
    paysum = 0
    buycars.each do |f|
      product = f.product
      buycar_param = {
          id: f.id,
          number: f.number,
          price: f.price,
          product_id: product.id,
          name: product.name,
          cover: product.cover,
          productcla_ids: product.productclas.ids
      }
      paysum += f.number.to_f * f.price.to_f
      buycararr.push buycar_param
    end
    param = {
        buycars: buycararr,
        paysum: paysum.round(2)
    }
    param
  end
end
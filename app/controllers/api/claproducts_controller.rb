class Api::ClaproductsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    ispro = 0
    shopusers = user.shopusers.where('member <> ?', 0)
    ispro = 1 if shopusers.size > 0
    productcla = Productcla.find_by_keyword(params[:searchkey])
    products = productcla.products.where(onsale: 1).page(params[:page]).per(10)
    final = 0
    final = 1 if products.last_page? || products.out_of_range?
    productarr = []
    products.each do |f|
      price = f.price
      price = f.proprice.to_f if f.proprice.to_f > 0 && ispro == 1
      product_param = {
          id: f.id,
          name: f.name.to_s,
          img: f.cover.to_s,
          price: price,
          priceMarket: f.price
      }
      productarr.push product_param
    end
    param = {
        final: final,
        data: productarr
    }
    return_api(param)
  end
end

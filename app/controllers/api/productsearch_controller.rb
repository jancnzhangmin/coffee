class Api::ProductsearchController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    products = Product.where('onsale = ? and name like ?', 1, "%#{params[:searchkey]}%")
    order = 'asc'
    order = 'desc' if params[:order] == "2"
    if params[:ordertype] == 'sale'
      products = products.order("salecount #{order}")
    elsif params[:ordertype] == 'price'
      products = products.order("price #{order}")
    elsif  params[:ordertype] == 'evaluate'
      products = products.order(" comp #{order}")
    end
    shopusers = user.shopusers.where('member <> ?', 0)
    products = products.page(params[:page]).per(10)
    final = 0
    final = 1 if products.last_page? || products.out_of_range?
    productarr = []
    products.each do |f|
      price = f.price
      price = f.proprice.to_f if shopusers.size > 0 && f.proprice.to_f > 0
      activetag = []
      active = Backrun.get_product_summary(f.id, user.id)
      if active.size > 0
        activetag = active.map{|n|n[:activetag]}
      end
      product_param = {
          id: f.id,
          name: f.name,
          price: price,
          img: f.cover,
          priceMarket: f.price,
          proprice: f.proprice.to_f,
          activetag: activetag
      }
      productarr.push product_param
    end
    param = {
        final: final,
        products: productarr
    }
    return_api(param)
  end
end

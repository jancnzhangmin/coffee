class Api::ProductdetailsController < ApplicationController
  def index
    product = Product.find(params[:productid])
    showparamarr = []
    showparams = product.showparams.order('corder')
    showparams.each do |f|
      show_param = {
          key: f.showkey,
          value: f.showvalue
      }
      showparamarr.push show_param
    end
    product_param = {
        id: product.id,
        banners: product.productbanners.order('corder').map(&:banner),
        name: product.name.to_s,
        subname: product.subname.to_s,
        price: product.price.to_f,
        showparams: showparamarr,
        content: product.content
    }
    return_api(product_param)
  end

  def create
    debugger
  end
end

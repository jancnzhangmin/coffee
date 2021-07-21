class Api::ProductdetailsController < ApplicationController
  def index
    product = Product.find(params[:productid])
    product.update(pv: product.pv.to_i + 1)
    showparamarr = []
    showparams = product.showparams.order('corder')
    showparams.each do |f|
      show_param = {
          key: f.showkey,
          value: f.showvalue
      }
      showparamarr.push show_param
    end
    pv = product.pv.to_f
    if pv >= 10000
      pv = (pv / 10000).round(1).to_s + '万次'
    else
      pv = pv.to_i.to_s + '次'
    end
    salecount = product.salecount.to_f
    if salecount >= 10000
      salecount = (salecount / 10000).round(1).to_s + '万件'
    else
      salecount = salecount.to_i.to_s + '件'
    end
    product_param = {
        id: product.id,
        banners: product.productbanners.order('corder').map(&:banner),
        name: product.name.to_s,
        subname: product.subname.to_s,
        price: product.price.to_f,
        showparams: showparamarr,
        content: product.content,
        pv: pv,
        salecount: salecount
    }
    return_api(product_param)
  end

  def create

  end
end

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

    buyparamarr = []
    buyparams = product.buyparams.order('corder')
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

    user = User.find_by_token(params[:token])
    proprice = product.price.to_f
    shopusers = user.shopusers.where('member <> ?', 0)
    proprice = product.proprice.to_f if shopusers.size > 0 && product.proprice.to_f > 0
    startnumber = product.retailstartnumber.to_i
    startnumber = product.startnumber.to_i if shopusers.size > 0
    product_param = {
        id: product.id,
        banners: product.productbanners.order('corder').map(&:banner),
        name: product.name.to_s,
        subname: product.subname.to_s,
        price: product.price.to_f,
        proprice: proprice,
        showparams: showparamarr,
        content: product.content,
        pv: pv,
        salecount: salecount,
        buyparams: buyparamarr,
        cover: product.cover,
        onsale: product.onsale.to_i,
        startnumber: startnumber,
        propriceorgin: product.proprice,
        active: Backrun.get_product_summary(product.id, user.id)
    }
    return_api(product_param)
  end

  def create

  end
end

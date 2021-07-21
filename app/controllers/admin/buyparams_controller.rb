class Admin::BuyparamsController < ApplicationController
  def index
    product = Product.find(params[:product_id])
    buyparams = product.buyparams.order('corder')
    buyparamarr = []
    buyparams.each do |buyparam|
      buyparam_param = {
          id: buyparam.id,
          param: buyparam.param,
          corder: buyparam.corder,
          buyparamvaluecount: buyparam.buyparamvalues.size
      }
      buyparamarr.push buyparam_param
    end
    param = {
        product: product.name,
        data: buyparamarr
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    product = Product.find(params[:product_id])
    product.buyparams.create(param: data["param"])
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    buyparam = Buyparam.find(params[:id])
    buyparam.update(param: data["param"])
    return_res('')
  end

  def destroy
    buyparam = Buyparam.find(params[:id])
    buyparam.destroy
    return_res('')
  end

  def sort
    from_id = params[:from_id].to_i
    to_id = params[:to_id].to_i
    product = Product.find(params[:product_id])
    Buyparam.transaction do
      if from_id > to_id
        buyparams = product.buyparams.where('corder <= ? and corder >= ?', from_id, to_id).order('corder asc')
      elsif to_id > from_id
        buyparams = product.buyparams.where('corder >= ? and corder <= ?', from_id, to_id).order('corder desc')
      end
      buyparams.each_with_index do |item,index|
        nextproductcla = buyparams[index + 1]
        if nextproductcla
          item.update(corder: nextproductcla.corder)
        end
      end
      buyparams.last.update(corder: to_id)
    end
    return_res('')
  end
end

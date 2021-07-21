class Admin::BuyparamvaluesController < ApplicationController
  def index
    product = Product.find(params[:product_id])
    buyparam = Buyparam.find(params[:buyparam_id])
    buyparamvalues = buyparam.buyparamvalues.order('corder')
    buyparamarr = []
    buyparamvalues.each do |buyparam|
      buyparam_param = {
          id: buyparam.id,
          cover: buyparam.cover,
          name: buyparam.name,
          price: buyparam.price,
          cost: buyparam.cost,
          corder: buyparam.corder
      }
      buyparamarr.push buyparam_param
    end
    param = {
        product: product.name + '-' + buyparam.param,
        data: buyparamarr
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    buyparam = Buyparam.find(params[:buyparam_id])
    buyparam.buyparamvalues.create(name: data["name"], cover: data["cover"], price: data["price"], cost: data["cost"])
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    buyparamvalue = Buyparamvalue.find(params[:id])
    buyparamvalue.update(name: data["name"], cover: data["cover"], price: data["price"], cost: data["cost"])
    return_res('')
  end

  def destroy
    buyparamvalue = Buyparamvalue.find(params[:id])
    buyparamvalue.destroy
    return_res('')
  end

  def sort
    from_id = params[:from_id].to_i
    to_id = params[:to_id].to_i
    buyparam = Buyparam.find(params[:buyparam_id])
    Buyparamvalue.transaction do
      if from_id > to_id
        buyparamvalues = buyparam.buyparamvalues.where('corder <= ? and corder >= ?', from_id, to_id).order('corder asc')
      elsif to_id > from_id
        buyparamvalues = buyparam.buyparamvalues.where('corder >= ? and corder <= ?', from_id, to_id).order('corder desc')
      end
      buyparamvalues.each_with_index do |item,index|
        nextproductcla = buyparamvalues[index + 1]
        if nextproductcla
          item.update(corder: nextproductcla.corder)
        end
      end
      buyparamvalues.last.update(corder: to_id)
    end
    return_res('')
  end
end

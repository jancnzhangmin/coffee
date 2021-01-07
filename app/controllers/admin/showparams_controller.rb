class Admin::ShowparamsController < ApplicationController
  def index
    product = Product.find(params[:product_id])
    showparams = product.showparams.order('corder')
    showparamarr = []
    showparams.each do |f|
      showparam_param = {
          id: f.id,
          showkey: f.showkey,
          showvalue: f.showvalue,
          corder: f.corder
      }
      showparamarr.push showparam_param
    end
    param = {
        data: showparamarr
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    product = Product.find(params[:product_id])
    product.showparams.create(showkey: data["showkey"], showvalue: data["showvalue"])
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    showparam = Showparam.find(params[:id])
    showparam.update(showkey: data["showkey"], showvalue: data["showvalue"])
    return_res('')
  end

  def destroy
    showparam = Showparam.find(params[:id])
    showparam.destroy
    return_res('')
  end

  def sort
    product = Product.find(params[:product_id])
    from_id = params[:from_id].to_i
    to_id = params[:to_id].to_i
    Showparam.transaction do
      if from_id > to_id
        showparams = product.showparams.where('corder <= ? and corder >= ?', from_id, to_id).order('corder asc')
      elsif to_id > from_id
        showparams = product.showparams.where('corder >= ? and corder <= ?', from_id, to_id).order('corder desc')
      end
      showparams.each_with_index do |item,index|
        nextdata = showparams[index + 1]
        if nextdata
          item.update(corder: nextdata.corder)
        end
      end
      showparams.last.update(corder: to_id)
    end
    return_res('')
  end
end

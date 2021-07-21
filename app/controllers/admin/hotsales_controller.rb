class Admin::HotsalesController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      hotsales = Hotsale.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      hotsales = Hotsale.all.order('corder')
    end
    total = hotsales.size
    allproducts = Product.where('id not in (?)', hotsales.map(&:product_id) + [0])
    hotsales = hotsales.page(params[:page]).per(params[:per])
    hotsalearr = []
    hotsales.each do |hotsale|
      hotsale_param = {
          id: hotsale.id,
          name: hotsale.product.name,
          corder: hotsale.corder,
          cover: hotsale.product.cover
      }
      hotsalearr.push hotsale_param
    end
    allproductarr = []
    allproducts.each do |allproduct|
      allproduct_param = {
          value: allproduct.id,
          label: allproduct.name
      }
      allproductarr.push allproduct_param
    end
    param = {
        data: hotsalearr,
        total: total,
        productoptions: allproductarr
    }
    return_res(param)
  end

  def create
    Hotsale.create(product_id: params[:productvalue])
    return_res('')
  end

  def destroy
    hotsale = Hotsale.find(params[:id])
    hotsale.destroy
    return_res('')
  end

  def sort
    from_id = params[:from_id].to_i
    to_id = params[:to_id].to_i
    Hotsale.transaction do
      if from_id > to_id
        hotsales = Hotsale.where('corder <= ? and corder >= ?', from_id, to_id).order('corder asc')
      elsif to_id > from_id
        hotsales = Hotsale.where('corder >= ? and corder <= ?', from_id, to_id).order('corder desc')
      end
      hotsales.each_with_index do |item,index|
        nextproductcla = hotsales[index + 1]
        if nextproductcla
          item.update(corder: nextproductcla.corder)
        end
      end
      hotsales.last.update(corder: to_id)
    end
    return_res('')
  end
end

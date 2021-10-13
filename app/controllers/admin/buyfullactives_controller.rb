class Admin::BuyfullactivesController < ApplicationController
  def index
      if params[:order] && params[:prop] && params[:prop].size > 0
        order = 'asc'
        order = 'desc' if params[:order] == 'descending'
        buyfullactives = Buyfullactive.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
      else
        buyfullactives = Buyfullactive.all.order('id desc')
      end
      total = buyfullactives.size
      buyfullactives = buyfullactives.page(params[:page]).per(params[:per])
      buyfullactivearr = []
      buyfullactives.each do |buyfullactive|
        buyfullactive_param = {
            id: buyfullactive.id,
            cover: buyfullactive.cover,
            name: buyfullactive.name,
            nametag: buyfullactive.nametag,
            begintime: buyfullactive.begintime.strftime('%Y-%m-%d %H:%M:%S'),
            endtime: buyfullactive.endtime.strftime('%Y-%m-%d %H:%M:%S'),
            status: buyfullactive.status.to_i,
            product: Product.find(buyfullactive.product_id).name
        }
        buyfullactivearr.push buyfullactive_param
      end
      param = {
          data: buyfullactivearr,
          total: total
      }
      return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    status = 0
    status = 1 if data["state"]
    Buyfullactive.create(
        name: data["name"],
        nametag: data["nametag"],
        begintime: data["daterange"][0],
        endtime: data["daterange"][1],
        summary: data["summary"],
        price: data["price"],
        product_id: data["product_id"],
        cover: data["cover"],
        status: status
    )
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    status = 0
    status = 1 if data["state"]
    buyfullactive = Buyfullactive.find(params[:id])
    buyfullactive.update(
        name: data["name"],
        nametag: data["nametag"],
        begintime: data["daterange"][0],
        endtime: data["daterange"][1],
        summary: data["summary"],
        price: data["price"],
        product_id: data["product_id"],
        cover: data["cover"],
        status: status
    )
    return_res('')
  end

  def show
    buyfullactive = Buyfullactive.find(params[:id])
    buyfullactive_param = {
        id: buyfullactive.id,
        name: buyfullactive.name,
        nametag: buyfullactive.nametag,
        begintime: buyfullactive.begintime,
        endtime: buyfullactive.endtime,
        summary: buyfullactive.summary,
        price: buyfullactive.price,
        product_id: buyfullactive.product_id,
        cover: buyfullactive.cover,
        status: buyfullactive.status
    }
    return_res(buyfullactive_param)
  end

  def destroy
    buyfullactive = Buyfullactive.find(params[:id])
    buyfullactive.destroy
    return_res('')
  end
end

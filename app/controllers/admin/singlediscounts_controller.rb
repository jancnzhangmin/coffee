class Admin::SinglediscountsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      siglediscounts = Singlediscount.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      siglediscounts = Singlediscount.all
    end
    total = siglediscounts.size
    siglediscounts = siglediscounts.page(params[:page]).per(params[:per])
    siglediscountarr = []
    siglediscounts.each do |siglediscount|
      siglediscount_param = {
          id: siglediscount.id,
          name: siglediscount.name,
          product: siglediscount.product.name,
          product_id: siglediscount.product_id,
          buynumber: siglediscount.buynumber,
          discount: siglediscount.discount,
          begintime: siglediscount.begintime,
          endtime: siglediscount.endtime,
          begintimestr: siglediscount.begintime.strftime('%Y-%m-%d %H:%M:%S'),
          endtimestr: siglediscount.endtime.strftime('%Y-%m-%d %H:%M:%S'),
          state: siglediscount.status
      }
      siglediscountarr.push siglediscount_param
    end
    allproductarr = []
    allproducts = Product.all
    allproducts.each do |allproduct|
      allproduct_param = {
          value: allproduct.id,
          label: allproduct.name
      }
      allproductarr.push allproduct_param
    end
    param = {
        data: siglediscountarr,
        total: total,
        productoptions: allproductarr
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    status = 0
    status = 1 if data["state"]
    Singlediscount.create(
        name: data["name"],
        product_id: data["productvalue"],
        buynumber: data["buynumber"],
        discount: data["discount"],
        begintime: data["range"][0],
        endtime: data["range"][1],
        status: status
    )
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    status = 0
    status = 1 if data["state"]
    signlediscount = Singlediscount.find(params[:id])
    signlediscount.update(
        name: data["name"],
        product_id: data["productvalue"],
        buynumber: data["buynumber"],
        discount: data["discount"],
        begintime: data["range"][0],
        endtime: data["range"][1],
        status: status
    )
    return_res('')
  end

  def destroy
    signlediscount = Singlediscount.find(params[:id])
    signlediscount.destroy
    return_res('')
  end
end

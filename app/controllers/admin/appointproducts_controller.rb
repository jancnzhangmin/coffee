class Admin::AppointproductsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      appointproducts = Appointproduct.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      appointproducts = Appointproduct.all.order('id desc')
    end
    total = appointproducts.size
    appointproducts = appointproducts.page(params[:page]).per(params[:per])
    appointproductarr = []
    appointproducts.each do |appointproduct|
      appointproduct_param = {
          id: appointproduct.id,
          name: appointproduct.name,
          count: appointproduct.appointproductdetails.size
      }
      appointproductarr.push appointproduct_param
    end
    param = {
        data: appointproductarr,
        total: total
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    Appointproduct.create(
        name: data["name"],
        )
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    appointproduct = Appointproduct.find(params[:id])
    appointproduct.update(
        name: data["name"],
        )
    return_res('')
  end

  def destroy
    appointproduct = Appointproduct.find(params[:id])
    appointproduct.destroy
    return_res('')
  end
end

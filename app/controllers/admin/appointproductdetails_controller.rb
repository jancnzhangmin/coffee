class Admin::AppointproductdetailsController < ApplicationController
  def index
    appointproduct = Appointproduct.find(params[:appointproduct_id])
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      appointproductdetails = appointproduct.appointproductdetails.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      appointproductdetails = appointproduct.appointproductdetails
    end
    total = appointproductdetails.size
    appointproductdetails = appointproductdetails.page(params[:page]).per(params[:per])
    appointproductdetailarr = []
    appointproductdetails.each do |appointproductdetail|
      product = Product.find(appointproductdetail.product_id)
      appointproductdetail_param = {
          id: appointproductdetail.id,
          product: product.name,
          product_id: appointproductdetail.product_id,
          cover: product.cover,
          number: appointproductdetail.number
      }
      appointproductdetailarr.push appointproductdetail_param
    end
    products = Product.where('id not in (?)', appointproduct.appointproductdetails.map(&:product_id) + [0])
    productarr = []
    products.each do |f|
      product_param = {
          value: f.id,
          label: f.name
      }
      productarr.push product_param
    end
    allproducts = Product.all
    allproductarr = []
    allproducts.each do |f|
      product_param = {
          value: f.id,
          label: f.name
      }
      allproductarr.push product_param
    end
    param = {
        data: appointproductdetailarr,
        total: total,
        products: productarr,
        allproducts: allproductarr,
        appointproductname: appointproduct.name
    }
    return_res(param)
  end

  def create
    appointproduct = Appointproduct.find(params[:appointproduct_id])
    data = JSON.parse(params[:data])
    appointproduct.appointproductdetails.create(
        product_id: data["product_id"],
        number: data["number"]
        )
    return_res('')
  end

  def update
    appointproductdetail = Appointproductdetail.find(params[:id])
    data = JSON.parse(params[:data])
    appointproductdetail.update(
        product_id: data["product_id"],
        number: data["number"]
    )
    return_res('')
  end

  def destroy
    appointproductdetail = Appointproductdetail.find(params[:id])
    appointproductdetail.destroy
    return_res('')
  end
end

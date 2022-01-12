class Admin::LuckdrawdetailsController < ApplicationController
  def index
    luckdraw = Luckdraw.find(params[:luckdraw_id])
    luckdrawdetails = luckdraw.luckdrawdetails.order('corder')
    luckdrawdetailarr = []
    luckdrawdetails.each do |luckdrawdetail|
      product = Product.find_by(id: luckdrawdetail.product_id)
      productname = ""
      productname = product.name if product
      productname = "谢谢参与" if luckdrawdetail.thank == 1
      winningrate = luckdrawdetail.hitrate / luckdrawdetails.sum('hitrate')
      luckdrawdetail_param = {
          id: luckdrawdetail.id,
          product_id: luckdrawdetail.product_id,
          productname: productname,
          winningrate: (winningrate * 100).round(3).to_s + '%',
          number: luckdrawdetail.number,
          hitrate: luckdrawdetail.hitrate,
          thank: luckdrawdetail.thank,
          givenumber: luckdrawdetail.givenumber,
          appointproduct_id: luckdrawdetail.appointproduct_id,
          corder: luckdrawdetail.corder
      }
      luckdrawdetailarr.push luckdrawdetail_param
    end
    products = Product.where(onsale: 1)
    productarr = []
    products.each do |product|
      product_param = {
          value: product.id,
          label: product.name
      }
      productarr.push product_param
    end
    appointproducts = Appointproduct.all
    appointproductarr = []
    appointproducts.each do |appointproduct|
      appointproduct_param = {
          value: appointproduct.id,
          label: appointproduct.name
      }
      appointproductarr.push appointproduct_param
    end
    param = {
        data: luckdrawdetailarr,
        products: productarr,
        appointproducts: appointproductarr,
        luckdrawname: luckdraw.name
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    luckdraw = Luckdraw.find(params[:luckdraw_id])
    thank = 0
    thank = 1 if data["thank"]
    luckdraw.luckdrawdetails.create(product_id: data["product_id"], appointproduct_id: data["appointproduct_id"], hitrate: data["hitrate"], thank: thank)
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    luckdrawdetail = Luckdrawdetail.find(params[:id])
    thank = 0
    thank = 1 if data["thank"]
    luckdrawdetail.update(product_id: data["product_id"], appointproduct_id: data["appointproduct_id"], hitrate: data["hitrate"], thank: thank)
    return_res('')
  end

  def destroy
    luckdrawdetail = Luckdrawdetail.find(params[:id])
    luckdrawdetail.destroy
    return_res('')
  end

  def sort
    from_id = params[:from_id].to_i
    to_id = params[:to_id].to_i
    luckdraw = Luckdraw.find(params[:luckdraw_id])
    Luckdrawdetail.transaction do
      if from_id > to_id
        luckdrawdetails = luckdraw.luckdrawdetails.where('corder <= ? and corder >= ?', from_id, to_id).order('corder asc')
      elsif to_id > from_id
        luckdrawdetails = luckdraw.luckdrawdetails.where('corder >= ? and corder <= ?', from_id, to_id).order('corder desc')
      end
      luckdrawdetails.each_with_index do |item,index|
        nextluck = luckdrawdetails[index + 1]
        if nextluck
          item.update(corder: nextluck.corder)
        end
      end
      luckdrawdetails.last.update(corder: to_id)
    end
    return_res('')
  end
end

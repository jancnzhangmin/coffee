class Admin::ShopfirstsController < ApplicationController
  def index
    shopfirsts = Shopfirst.all.order('id desc')
    shopfirstarr = []
    shopfirsts.each do |f|
      shopfirst_param = {
          id: f.id,
          name: f.name,
          status: f.status.to_i,
          begintime: f.begintime.strftime('%Y-%m-%d %H:%M:%S'),
          endtime: f.endtime.strftime('%Y-%m-%d %H:%M:%S')
      }
      shopfirstarr.push shopfirst_param
    end
    return_res(shopfirstarr)
  end

  def create
    data = JSON.parse(params[:data])
    state = 0
    state = 1 if data["state"]
    Shopfirst.create(name: data["name"], begintime: Time.parse(data["daterange"][0]).localtime, endtime: Time.parse(data["daterange"][1]).localtime, status: state, summary: data["summary"])
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    state = 0
    state = 1 if data["state"]
    shopfirst = Shopfirst.find(params[:id])
    shopfirst.update(name: data["name"], begintime: Time.parse(data["daterange"][0]).localtime, endtime: Time.parse(data["daterange"][1]).localtime, status: state, summary: data["summary"])
    return_res('')
  end

  def destroy
    shopfirst = Shopfirst.find(params[:id])
    shopfirst.destroy
    return_res('')
  end

  def getproduct
    products = Product.all
    productarr = []
    products.each do |f|
      product_param = {
          value: f.id,
          label: f.name
      }
      productarr.push product_param
    end
    return_res(productarr)
  end

  def show
    shopfirst = Shopfirst.find(params[:id])
    shopfirst_param = {
        id: shopfirst.id,
        name: shopfirst.name,
        begintime: shopfirst.begintime.strftime('%Y-%m-%d %H:%M:%S'),
        endtime: shopfirst.endtime.strftime('%Y-%m-%d %H:%M:%S'),
        status: shopfirst.status.to_i,
        summary: shopfirst.summary
    }
    return_res(shopfirst_param)
  end
end

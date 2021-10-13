class Admin::BuyfullactivedetailsController < ApplicationController
  def index
    buyfullactive = Buyfullactive.find(params[:buyfullactive_id])
    buyfullactivedetails = buyfullactive.buyfullactivedetails.order('buynumber')
    buyfullactivedetailarr = []
    buyfullactivedetails.each do |buyfullactivedetail|
      buyfullactivedetail_param = {
          id: buyfullactivedetail.id,
          buynumber: buyfullactivedetail.buynumber,
          givenumber: buyfullactivedetail.givenumber,
          product: Product.find(buyfullactivedetail.giveproduct_id).name,
          giveproduct_id: buyfullactivedetail.giveproduct_id
      }
      buyfullactivedetailarr.push buyfullactivedetail_param
    end
    param = {
        activename: buyfullactive.name,
        data: buyfullactivedetailarr
    }
    return_res(param)
  end

  def create
    buyfullactive = Buyfullactive.find(params[:buyfullactive_id])
    data = JSON.parse(params[:data])
    buyfullactive.buyfullactivedetails.create(
        buynumber: data["buynumber"],
        givenumber: data["givenumber"],
        giveproduct_id: data["giveproduct_id"]
    )
    return_res('')
  end

  def update
    buyfullactivedetail = Buyfullactivedetail.find(params[:id])
    data = JSON.parse(params[:data])
    buyfullactivedetail.update(
        buynumber: data["buynumber"],
        givenumber: data["givenumber"],
        giveproduct_id: data["giveproduct_id"]
    )
    return_res('')
  end

  def destroy
    buyfullactivedetail = Buyfullactivedetail.find(params[:id])
    buyfullactivedetail.destroy
    return_res('')
  end
end

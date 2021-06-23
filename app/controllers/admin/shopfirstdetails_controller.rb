class Admin::ShopfirstdetailsController < ApplicationController
  def index
    shopfirst = Shopfirst.find(params[:shopfirst_id])
    shopfirstdetails = shopfirst.shopfirstdetails
    shopfirstdetailarr = []
    shopfirstdetails.each do |f|
      shopfirstdetail_param = {
          id: f.id,
          buyproduct: Product.find(f.buyproduct_id).name,
          buyproduct_id: f.buyproduct_id,
          buynumber: f.buynumber,
          giveproduct: Product.find(f.giveproduct_id).name,
          giveproduct_id: f.giveproduct_id,
          givenumber: f.givenumber
      }
      shopfirstdetailarr.push shopfirstdetail_param
    end
    return_res(shopfirstdetailarr)
  end

  def create
    shopfirst = Shopfirst.find(params[:shopfirst_id])
    data = JSON.parse(params[:data])
    shopfirst.shopfirstdetails.create(buyproduct_id: data["buyproduct_id"], buynumber: data["buynumber"], giveproduct_id: data["giveproduct_id"], givenumber: data["givenumber"])
    return_res('')
  end

  def update
    shopfirstdetail = Shopfirstdetail.find(params[:id])
    data = JSON.parse(params[:data])
    shopfirstdetail.update(buyproduct_id: data["buyproduct_id"], buynumber: data["buynumber"], giveproduct_id: data["giveproduct_id"], givenumber: data["givenumber"])
    return_res('')
  end

  def destroy
    shopfirstdetail = Shopfirstdetail.find(params[:id])
    shopfirstdetail.destroy
    return_res('')
  end
end

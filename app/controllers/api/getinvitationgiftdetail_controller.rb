class Api::GetinvitationgiftdetailController < ApplicationController
  def index
    invitationgift = Invitationgift.find(params[:invitationgift_id])
    summary = invitationgift.summary
    appointproduct = Appointproduct.find(invitationgift.appointproduct_id)
    appointproductdetails = appointproduct.appointproductdetails.page(params[:page]).per(20)
    final = 0
    final = 1 if appointproductdetails.last_page? || appointproductdetails.out_of_range?
    detailarr = []
    appointproductdetails.each do |appointproductdetail|
      product = Product.find(appointproductdetail.product_id)
      appointproductdetail_param = {
          id: appointproductdetail.id,
          product_id: appointproductdetail.product_id,
          name: product.name,
          cover: product.cover,
          price: product.price,
          number: appointproductdetail.number
      }
      if product.onsale == 1
        detailarr.push appointproductdetail_param
      end
    end
    param = {
        summary: summary,
        final: final,
        data: detailarr
    }
    return_api(param)
  end
end

class Api::GetinvitationgiftcoverController < ApplicationController
  def index
    invitationgift = Invitationgift.where('status = ? and begintime <= ? and endtime >= ?', 1, Time.now, Time.now).last
    param = ""
    if invitationgift
      product = Product.find(invitationgift.product_id)
      param = {
          id: invitationgift.id,
          cover: invitationgift.cover,
          productcover: product.cover,
          productname: product.name
      }
    end
    return_api(param)
  end
end

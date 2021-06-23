class Api::PostersController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    product = Product.find(params[:product_id])
    posters = product.posters
    posterarr = []
    posters.each do |f|
      if f.content.to_s.size > 0
        posterarr.push JSON.parse(f.content)
      end
    end
    param = {
        userid: user.id,
        posters: posterarr
    }
    return_api(param)
  end
end

class Api::GetgiftproductController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    param = Backrun.getgiftproduct(user.id)
    return_api(param)
  end
end

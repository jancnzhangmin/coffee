class Api::EvaluatesController < ApplicationController
  def create
    order = Order.find(params[:order_id])
    order.update(evaluatestatus: 1, evaluatetime: Time.now)
    user = User.find_by_token(params[:token])
    evaluate = user.evaluates.create(speed: params[:speed], quality: params[:quality], summary: params[:summary], describe: params[:describe], status: 1, systemstatus: 1)
    params[:imgs].each do |f|
      evaluate.evaluateimgs.create(evaluateimg: f)
    end
    order.orderdetails.each do |f|
      product = f.product
      product.evaluates << evaluate
    end
    return_api('')
  end
end

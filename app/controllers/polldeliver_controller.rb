class PolldeliverController < ApplicationController
  def create
    result = JSON.parse(params[:param])
    orderdelivers = Orderdeliver.where('nu = ?',result["lastResult"]["nu"])
    orderdelivers.each do |orderdeliver|
      begin
        orderdeliver.update(cdata: result['lastResult']['data'].to_json, state: result['lastResult']['state'])
        order = orderdeliver.order
        check_state(order.id)
      rescue
        logger.info 'json出错了'
      end
    end
    render json: '{"result":true,"returnCode":"200","message":"接收成功"}'
  end

  private

  def check_state(orderid)
    order = Order.find(orderid)
    orderdelivers = order.orderdelivers
    ischeck = true
    orderdelivers.each do |f|
      if f.state.to_i != 3
        ischeck = false
      end
    end
    if ischeck && order.receivestatus.to_i == 0
      order.update(receivestatus: 1, receivetime: Time.now)
      ReceiveafterJob.perform_later(order.id)
    end
  end
end

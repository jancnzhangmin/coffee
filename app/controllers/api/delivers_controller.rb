class Api::DeliversController < ApplicationController
  def index
    order = Order.find(params[:order_id])
    orderdelivers = order.orderdelivers
    orderdeliverarr = []
    orderdelivers.each do |f|
      orderdeliver_param = {
          id: f.id,
          com: f.com,
          nu: f.nu,
          state: f.state.to_i,
          cdata: f.cdata,
          company: f.company,
          addr: order.province.to_s + order.city.to_s + order.district.to_s + order.address.to_s,
          ischeck: f.state.to_i == 3 ? 1 : 0
      }
      orderdeliverarr.push orderdeliver_param
    end
    return_api(orderdeliverarr)
  end

  def confirmdeliver
    order = Order.find(params[:order_id])
    order.update(receivestatus: 1, receivetime: Time.now)
    ReceiveafterJob.perform_later(order.id)
  end
end

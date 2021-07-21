class AutoreceiveJob < ApplicationJob
  queue_as :default

  def perform(orderid)
    order = Order.find_by(id: orderid)
    if order && order.receivestatus.to_i == 0
      order.update(receivestatus: 1, receivetime: Time.now)
      ReceiveafterJob.perform_later(order.id)
    end
  end
end

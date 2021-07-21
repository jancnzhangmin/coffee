class DeletestayorderJob < ApplicationJob
  queue_as :default

  def perform(orderid)
    order = Order.find_by(id: orderid)
    if order && order.paystatus.to_i == 0
      order.destroy
    end
  end
end

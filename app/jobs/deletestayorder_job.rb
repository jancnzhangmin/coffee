class DeletestayorderJob < ApplicationJob
  queue_as :default

  def perform(orderid)
    order = Order.find_by(id: orderid)
    if order && order.paystatus.to_i == 0
      orderdetails = order.orderdetails
      orderdetails.each do |orderdetail|
        if orderdetail.giftdepot_id.to_i > 0
          giftdepot = Giftdepot.find(orderdetail.giftdepot_id)
          giftdepot.update(usedstatus: 0)
        end
      end
      order.destroy
    end
  end
end

class AutoevaluateJob < ApplicationJob
  queue_as :default

  def perform(orderid)
    order = Order.find_by(id: orderid)
    if order && order.evaluatestatus.to_i == 0
      order.update(evaluatestatus: 1, evaluatetime: Time.now)
      user = order.user
      evaluate = user.evaluates.create(speed: 5, quality: 5, summary: '', describe: '', status: 0, systemstatus: 0)
      orderdetails = order.orderdetails
      orderdetails.each do |f|
        product = f.product
        product.evaluates << evaluate
        EvaluatesumJob.perform_later(product.id)
      end
    end
  end
end

class ReceiveafterJob < ApplicationJob
  queue_as :default

  def perform(orderid)
    order = Order.find_by(orderid)
    if order
      incomes = Income.where('ordernumber = ?', order.ordernumber)
      incomes.each do |f|
        f.update(status: 1)
      end
    end
  end
end

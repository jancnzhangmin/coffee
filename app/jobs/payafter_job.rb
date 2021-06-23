class PayafterJob < ApplicationJob
  queue_as :default

  def perform(orderid)
    Backrun.cal_distribute(orderid)
    Backrun.cal_teamprofit(orderid)
    Backrun.cal_rebate(orderid)
    Backrun.cal_profit(orderid)
    order = Order.find(orderid)
    user = order.user
    Backrun.teamupgrade(user.id)
    Backrun.shop_buysum(orderid)

  end
end

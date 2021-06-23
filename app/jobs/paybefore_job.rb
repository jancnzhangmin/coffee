class PaybeforeJob < ApplicationJob
  queue_as :default

  def perform(orderid)
    Backrun.cal_distribute(orderid)
    Backrun.cal_teamprofit(orderid)
    Backrun.cal_rebate(orderid)
    Backrun.cal_profit(orderid)
  end
end

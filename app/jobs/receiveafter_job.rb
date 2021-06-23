class ReceiveafterJob < ApplicationJob
  queue_as :default

  def perform(orderid)
    Backrun.payafter(orderid)
  end
end

class SendmpregmsgJob < ApplicationJob
  queue_as :default

  def perform(userid)
    Backrun.send_user_reg_msg(userid,'user')
  end
end

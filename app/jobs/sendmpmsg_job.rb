class SendmpmsgJob < ApplicationJob
  queue_as :default

  def perform(userid,data)
    Backrun.send_mp_msg(userid,data)
  end
end

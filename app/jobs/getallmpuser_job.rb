class GetallmpuserJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Backrun.get_all_mp_user_openid
  end
end

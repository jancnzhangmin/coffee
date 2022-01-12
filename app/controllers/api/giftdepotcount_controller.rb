class Api::GiftdepotcountController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    giftdepots = user.giftdepots.where(usedstatus: 0)
    giftdepotcount = 0
    giftdepots.each do |f|
      if f.created_at + f.expireday.days > Time.now
        giftdepotcount += f.number
      end
    end
    param = {
        giftdepotcount: giftdepotcount
    }
    return_api(param)
  end
end

class Api::PopmsgsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    popmsg = user.popmsg
    if !popmsg
      user.create_popmsg(poptime: Time.parse('2000-1-1 0:00:00'))
      popmsg = user.popmsg
    end
    giftdepots = user.giftdepots.where('created_at >= ? and usedstatus = ?', popmsg.poptime, 0)
    popcount = 0
    giftdepots.each do |f|
      if f.created_at + f.expireday.days > Time.now
        popcount += f.number
      end
    end
    param = {
        popcount: popcount
    }
    popmsg.update(poptime: Time.now)
    return_api(param)
  end
end

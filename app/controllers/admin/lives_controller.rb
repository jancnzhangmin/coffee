class Admin::LivesController < ApplicationController
  def index
    live = Live.first
    if !live
      live = Live.create(roomid: 0, status: 0)
    end
    live_param = {
        id: live.id,
        roomid: live.roomid,
        state: live.status
    }
    return_res(live_param)
  end

  def update
    live = Live.find(params[:id])
    data = JSON.parse(params[:data])
    status = 0
    status = 1 if data["state"]
    live.update(roomid: data["roomid"], status: status)
    return_res('')
  end
end

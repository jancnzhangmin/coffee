class Admin::LuckdrawsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      luckdraws = Luckdraw.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      luckdraws = Luckdraw.all.order('endtime desc')
    end
    total = luckdraws.size
    luckdraws = luckdraws.page(params[:page]).per(params[:per])
    luckdrawarr = []
    luckdraws.each do |luckdraw|
      luckdraw_param = {
          id: luckdraw.id,
          name: luckdraw.name,
          nametag: luckdraw.nametag,
          begintime: luckdraw.begintime,
          begintimestr: luckdraw.begintime.strftime('%Y-%m-%d %H:%M:%S'),
          endtime: luckdraw.endtime,
          endtimestr: luckdraw.endtime.strftime('%Y-%m-%d %H:%M:%S'),
          status: luckdraw.status
      }
      luckdrawarr.push luckdraw_param
    end
    param = {
        data: luckdrawarr,
        total: total
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    state = 0
    state = 1 if data["state"]
    Luckdraw.create(
        name: data["name"],
        nametag: data["nametag"],
        status: state,
        begintime: data["daterange"][0],
        endtime: data["daterange"][1]
    )
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    state = 0
    state = 1 if data["state"]
    luckdraw = Luckdraw.find(params[:id])
    luckdraw.update(
        name: data["name"],
        nametag: data["nametag"],
        status: state,
        begintime: data["daterange"][0],
        endtime: data["daterange"][1]
    )
    return_res('')
  end

  def destroy
    luckdraw = Luckdraw.find(params[:id])
    luckdraw.destroy
    return_res('')
  end
end

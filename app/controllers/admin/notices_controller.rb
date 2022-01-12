class Admin::NoticesController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      notices = Notice.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      notices = Notice.all.order('id desc')
    end
    total = notices.size
    notices = notices.page(params[:page]).per(params[:per])
    noticearr = []
    notices.each do |notice|
      notice_param = {
          id: notice.id,
          title: notice.title,
          content: notice.content,
          begintimestr: notice.begintime.strftime('%Y-%m-%d %H:%M:%S'),
          endtimestr: notice.endtime.strftime('%Y-%m-%d %H:%M:%S'),
          begintime: notice.begintime,
          endtime: notice.endtime,
          status: notice.status
      }
      noticearr.push notice_param
    end
    param = {
        data: noticearr,
        total: total
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    status = 0
    status = 1 if data["state"]
    Notice.create(
        title: data["title"],
        content: data["content"],
        begintime: data["daterange"][0],
        endtime: data["daterange"][1],
        status: status
    )
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    status = 0
    status = 1 if data["state"]
    notice = Notice.find(params[:id])
    notice.update(
        title: data["title"],
        content: data["content"],
        begintime: data["daterange"][0],
        endtime: data["daterange"][1],
        status: status
    )
    return_res('')
  end

  def show
    notice = Notice.find(params[:id])
    param = {
        id: notice.id,
        title: notice.title,
        content: notice.content,
        begintime: notice.begintime,
        endtime: notice.endtime,
        status: notice.status
    }
    return_res(param)
  end

  def destroy
    notice = Notice.find(params[:id])
    notice.destroy
    return_res('')
  end
end

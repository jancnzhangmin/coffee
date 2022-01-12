class Api::NoticesController < ApplicationController
  def index
    notices = Notice.where('begintime <= ? and endtime >=? and status = ?', Time.now, Time.now, 1)
    noticearr = []
    notices.each do |notice|
      notice_param = {
          id: notice.id,
          title: notice.title,
          content: notice.content
      }
      noticearr.push notice_param
    end
    return_api(noticearr)
  end
end

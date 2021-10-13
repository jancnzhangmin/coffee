class PolldeliverController < ApplicationController
  def create
    result = JSON.parse(params[:param])
    orderdelivers = Orderdeliver.where('nu = ?',result["lastResult"]["nu"])
    orderdelivers.each do |orderdeliver|
      begin
        order = orderdeliver.order
        if orderdeliver.cdata.to_s.size == 0
          data = {
              touser: user.openid,
              template_id: "yQtPa17c47ylsDl81RQBJBo-tj-yZPNb6JOJMsF6nFM",
              miniprogram: {
                  appid: Setting.first.appid,
                  path: "index"
              },
              data: {
                  first: {
                      value: "您购买的商品已经发货",
                  },
                  keyword1: {
                      value: order.ordernumber,
                  },
                  keyword2: {
                      value: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
                  },
                  keyword3: {
                      value: orderdeliver.company
                  },
                  keyword4: {
                      value: orderdeliver.nu
                  },
                  remark: {
                      value: "",
                  }
              }
          }
          SendmpmsgJob.perform_later(order.user.id, data.to_json)
        end

        orderdeliver.update(cdata: result['lastResult']['data'].to_json, state: result['lastResult']['state'])

        check_state(order.id)

      rescue
        logger.info 'json出错了'
      end
    end
    render json: '{"result":true,"returnCode":"200","message":"接收成功"}'
  end

  private

  def check_state(orderid)
    order = Order.find(orderid)
    orderdelivers = order.orderdelivers
    ischeck = true
    orderdelivers.each do |f|
      if f.state.to_i != 3
        ischeck = false
      end
    end
    if ischeck && order.receivestatus.to_i == 0
      order.update(receivestatus: 1, receivetime: Time.now)
      ReceiveafterJob.perform_later(order.id)
    end
  end
end

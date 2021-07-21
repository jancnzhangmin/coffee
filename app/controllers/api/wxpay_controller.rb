class Api::WxpayController < ApplicationController
  def prepay
    user = User.find_by_token(params[:token])
    order = Order.find(params[:order_id])
    payment_params = {
        body: '商品付款',
        out_trade_no: order.ordernumber,
        total_fee: (order.amount * 100).to_i,
        spbill_create_ip:  '127.0.0.1',
        notify_url: 'https://coffee.ysdsoft.com/api/wxpay/wxpay_notify',
        trade_type: 'JSAPI', # could be "JSAPI", "NATIVE" or "APP",
        openid: user.openid  # required when trade_type is `JSAPI`
    }
    result = WxPay::Service.invoke_unifiedorder(payment_params)
    $client ||= WeixinAuthorize::Client.new(Setting.first.appid, Setting.first.appsecret)
    sign_package = $client.get_jssign_package(request.url.split('#')[0])
    if result.nil?
      #render html: "no"
    else
      pay_ticket_param = {
          timeStamp: sign_package["timestamp"],
          nonceStr: sign_package["nonceStr"],
          package: "prepay_id=#{result['prepay_id']}",  #这里一定注意，不仅仅是prepay_id，还需要拼接上“prepay_id=”
          signType: "MD5",
          appId: WxPay.appid,
          key: WxPay.key
      }
      pay_ticket_param = {
          paySign: WxPay::Sign.generate(pay_ticket_param)  #然后我们手动进行paySign计算
      }.merge(pay_ticket_param)
      param = {
          pay_ticket_param: pay_ticket_param,
          sign_package: sign_package
      }
      return_api(param)
    end
  end

  def wxpay_notify
    result = Hash.from_xml(request.body.read)["xml"]
    if result['return_code'] == 'SUCCESS'
      order = Order.find_by_ordernumber(result['out_trade_no'])
      if order && order.paystatus.to_i == 0
        order.update(paystatus: 1, paytime: Time.now)
        orderdetails = order.orderdetails
        orderdetails.each do |orderdetail|
          product = orderdetail.product
          product.update(salecount: product.salecount.to_i + orderdetail.number)
        end
        PayafterJob.perform_later(order.id)
      end
    end
    render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
  end
end

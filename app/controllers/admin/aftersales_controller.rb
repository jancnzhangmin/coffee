class Admin::AftersalesController < ApplicationController
  def show
    order = Order.find(params[:id])
    orderarr = []
    if order.paystatus.to_i == 1 && order.deliverstatus.to_i == 0
      orderstatus = "待发"
    elsif order.deliverstatus.to_i == 1 && order.receivestatus.to_i == 0
      orderstatus = "待收"
    elsif order.receivestatus.to_i == 1 && order.evaluatestatus.to_i == 0
      orderstatus = "待评价"
    elsif order.evaluatestatus.to_i == 1
      orderstatus = "已完成"
    end
    order_param = {
        label1: '订单编号',
        value1: order.ordernumber,
        label2: '订单状态',
        value2: orderstatus
    }
    orderarr.push order_param

    order_param = {
        label1: '收货人',
        value1: order.contact.to_s + ' ' + order.contactphone.to_s,
        label2: '收货地址',
        value2: order.province.to_s + order.city.to_s + order.district.to_s + order.address.to_s
    }
    orderarr.push order_param
    order_param = {
        label1: '订单金额',
        value1: order.amount.to_s(:currency, unit: ''),
        label2: '下单时间',
        value2: order.paytime.strftime('%Y-%m-%d %H:%M:%S')
    }
    orderarr.push order_param

    orderdetails = order.orderdetails
    orderdetailarr = []
    orderdetails.each do |f|
      product = f.product
      cover = product.cover
      buyparam = []
      orderdetailparams = f.orderdetailparams
      orderdetailparams.each do |orderdetailparam|
        cover = Buyparamvalue.find(orderdetailparam.buyparamvalue_id).cover
        buyparam.push (orderdetailparam.buyparam + "：" + orderdetailparam.buyparamvalue)
      end
      orderdetail_param = {
          id: f.id,
          name: product.name,
          cover: cover,
          buyparam: buyparam.join(' '),
          number: f.number,
          price: f.price.to_s(:currency, unit: '')
      }
      orderdetailarr.push orderdetail_param
    end

    aftersales = order.aftersales
    aftersalearr = []
    aftersales.each do |aftersale|
      aftersale_param = {
          id: aftersale.id,
          contact: aftersale.contact,
          summary: aftersale.summary,
          reply: aftersale.reply,
          imgs: aftersale.aftersaleimgs.map(&:aftersaleimg),
          created_at: aftersale.created_at.strftime('%Y-%m-%d %H:%M:%S')
      }
      aftersalearr.push aftersale_param
    end

    param = {
        order: orderarr,
        orderdetails: orderdetailarr,
        aftersales: aftersalearr,
        afterstatus: order.afterstatus.to_i
    }
    return_res(param)
  end

  def update
    order = Order.find(params[:id])
    aftersale = order.aftersales.last
    data = JSON.parse(params[:data])
    aftersale.update(reply: data["reply"])
    order.update(afterstatus: 0)
    return_res('')
  end
end

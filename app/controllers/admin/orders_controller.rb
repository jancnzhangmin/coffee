class Admin::OrdersController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      orders = Order.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
      orders = orders.where('paystatus = 1')
    else
      orders = Order.all.order('id desc')
      orders = orders.where('paystatus = 1')
    end
    if params[:filtervalue].to_s.size > 0
      orders = orders.where('ordernumber like ? or contact like ? or contactphone like ?', "%#{params[:filtervalue]}%", "%#{params[:filtervalue]}%", "%#{params[:filtervalue]}%")
    end
    if params[:filterdate].to_s.size > 0
      orders = orders.where('paytime between ? and ?', Time.parse(params[:filterdate][0]).localtime.beginning_of_day, Time.parse(params[:filterdate][1]).localtime.end_of_day)
    end
    if params[:adcode].to_s.size > 0
      adcode = params[:adcode]
      while adcode.last == '0' && adcode.size > 0
        adcode.chop!
      end
      adcode = adcode.ljust(6,'_')
      orders = orders.where('adcode like ?', "#{adcode}")
    end
    delivercount = orders.where('deliverstatus = 0').size
    receivecount = orders.where('deliverstatus = 1 and receivestatus = 0').size
    evaluatecount = orders.where('receivestatus = 1 and evaluatestatus = 0').size
    finishcount = orders.where('evaluatestatus = 1').size
    aftercount = orders.where('afterstatus = 1').size
    allcount = orders.size
    if params[:filtercheck].to_s.size > 0
      collection = []
      if params[:filtercheck].include? '待发'
        collection.push 'deliverstatus = 0'
      end
      if params[:filtercheck].include? '待收'
        collection.push '(deliverstatus = 1 and receivestatus = 0)'
      end
      if params[:filtercheck].include? '待评价'
        collection.push '(receivestatus = 1 and evaluatestatus = 0)'
      end
      if params[:filtercheck].include? '已完成'
        collection.push 'evaluatestatus = 1'
      end
      if params[:filtercheck].include? '售后'
        collection.push 'afterstatus = 1'
      end
      orders = orders.where(collection.join(' or '))
    else
      orders = Order.where('id = 0')
    end
    total = orders.size
    amountcount = orders.sum('amount').to_s(:currency,unit:'')
    expresscount = Orderdeliver.where(order_id: orders.ids).size
    orders = orders.page(params[:page]).per(params[:per])
    orderarr = []
    orders.each do |order|
      state = '售后'
      if order.afterstatus.to_i == 0 && order.paystatus == 0
        state = '待付'
      elsif order.afterstatus.to_i == 0 && order.paystatus == 1 && order.deliverstatus == 0
        state = '待发'
      elsif order.afterstatus.to_i == 0 && order.deliverstatus == 1 && order.receivestatus == 0
        state = '待收'
      elsif order.afterstatus.to_i == 0 && order.receivestatus == 1 && order.evaluatestatus == 0
        state = '待评价'
      elsif order.afterstatus.to_i == 0 && order.evaluatestatus == 0
        state = '已完成'
      end
      created_at = order.created_at.strftime('%Y-%m-%d %H:%M:%S')
      created_at = order.paytime.strftime('%Y-%m-%d %H:%M:%S') if order.paytime
      orderdetails = order.orderdetails
      orderdetailarr = []
      orderdetails.each do |orderdetail|
        product = orderdetail.product
        orderdetail_param = {
            product: product.name,
            cover: product.cover,
            number: orderdetail.number,
            price: orderdetail.price
        }
        orderdetailarr.push orderdetail_param
      end
      order
      order_param = {
          id: order.id,
          ordernumber: order.ordernumber,
          contact: order.contact,
          contactphone: order.contactphone,
          address: order.province.to_s + order.city.to_s + order.district.to_s + order.address.to_s,
          state: state,
          amount: ActiveSupport::NumberHelper.number_to_currency(order.amount, unit:''),
          created_at: created_at,
          overflow: true,
          orderdetail: orderdetailarr,
          orderdetailcount: order.orderdetails.sum('number').to_i.to_s + ' 件商品',
          summary: order.summary,
          delivercount: order.orderdelivers.size
      }
      orderarr.push order_param
    end
    param = {
        data: orderarr,
        total: total,
        amountcount: amountcount,
        expresscount: expresscount,
        checkcount: {
            delivercount: delivercount,
            receivecount: receivecount,
            evaluatecount: evaluatecount,
            finishcount: finishcount,
            aftercount: aftercount,
            allcount: allcount
        }
    }
    return_res(param)
  end

  def judge_express
    nu = params[:nu]
    nu.tr!(',', ' ')
    num = nu.split(' ')
    num.uniq!
    order = Order.find(params[:orderid])
    num.each do |f|
      if f.size > 0
        com = Backrun.judge_express(f)
        com = com[0]["comCode"]
        expresscode = Expresscode.find_by_comcode(com)
        order.orderdelivers.create(com: expresscode.comcode, nu: f, company: expresscode.name)
      end
    end
    order.update(deliverstatus: 1)
    res_name = order.orderdelivers.map(&:company)
    res_name.uniq!
    return_res(res_name.join(' '))
  end
end

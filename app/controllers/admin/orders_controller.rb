class Admin::OrdersController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      orders = Order.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      orders = Order.all.order('id desc')
    end
    total = orders.size
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
          summary: order.summary
      }
      orderarr.push order_param
    end
    param = {
        data: orderarr,
        total: total
    }
    return_res(param)
  end
end

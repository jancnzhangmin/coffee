class Admin::ProfitsController < ApplicationController
  def index
  if params[:order] && params[:prop] && params[:prop].size > 0
    order = 'asc'
    order = 'desc' if params[:order] == 'descending'
    orders = Order.where('paystatus = ?', 1).order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
  else
    orders = Order.where('paystatus = ?', 1).order('paytime desc')
  end
  total = orders.size
  allsalesum = orders.sum('amount').to_s(:currency,unit:'')
  allprofitsum = orders.sum('profit').to_s(:currency,unit:'')
  orders = orders.page(params[:page]).per(params[:per])
  salesum = Order.where(id:orders.ids).sum('amount').to_s(:currency,unit:'')
  profitsum = Order.where(id:orders.ids).sum('profit').to_s(:currency, unit:'')
  orderarr = []
  orders.each do |f|
    state = '售后'
    if f.afterstatus.to_i == 0 && f.paystatus == 0
      state = '待付'
    elsif f.afterstatus.to_i == 0 && f.paystatus == 1 && f.deliverstatus == 0
      state = '待发'
    elsif f.afterstatus.to_i == 0 && f.deliverstatus == 1 && f.receivestatus == 0
      state = '待收'
    elsif f.afterstatus.to_i == 0 && f.receivestatus == 1 && f.evaluatestatus == 0
      state = '待评价'
    elsif f.afterstatus.to_i == 0 && f.evaluatestatus == 0
      state = '已完成'
    end
    order_param = {
        id: f.id,
        headurl: f.user.headurl.to_s,
        nickname: f.user.nickname.to_s,
        ordernumber: f.ordernumber,
        contact: f.contact,
        contactphone: f.contactphone,
        address: f.province.to_s + f.city.to_s + f.district.to_s + f.address.to_s,
        paytime: f.paytime.strftime('%Y-%m-%d %H:%M:%S'),
        amount: f.amount.to_f.to_s(:currency,unit:''),
        profit: f.profit.to_f.to_s(:currency, unit:''),
        state: state
    }
    orderarr.push order_param
  end
  param = {
      data: orderarr,
      total: total,
      datasum: {
          allsalesum: allsalesum,
          allprofitsum: allprofitsum,
          salesum: salesum,
          profitsum: profitsum
      }
  }
  return_res(param)
  end
end

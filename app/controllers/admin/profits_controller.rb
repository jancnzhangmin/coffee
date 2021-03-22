class Admin::ProfitsController < ApplicationController
  def index
  if params[:order] && params[:prop] && params[:prop].size > 0
    order = 'asc'
    order = 'desc' if params[:order] == 'descending'
    orders = Order.where('paystatus = ?', 1).order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
  else
    orders = Order.where('paystatus = ?', 1)
  end
  total = orders.size
  orders = orders.page(params[:page]).per(params[:per])
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
        amount: ActiveSupport::NumberHelper.number_to_currency(f.amount, unit:''),
        profit: ActiveSupport::NumberHelper.number_to_currency(f.profit, unit:''),
        state: state
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

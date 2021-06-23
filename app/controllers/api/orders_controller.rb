class Api::OrdersController < ApplicationController
  def createorder
    user = User.find_by_token(params[:token])
    buycars = user.buycars
    addr = Receiveaddr.find(params[:addr_id])
    shop_id = 0
    if params[:chooseproprice].to_i == 1
      shop_id = params[:shop_id].to_i
    end
    order = user.orders.create(
        ordernumber: Time.now.strftime("%Y%m%d") + user.id.to_s.rjust(5, '0') + Time.now.strftime("%H%M%S"),
        contact: addr.contact,
        contactphone: addr.contactphone,
        province: addr.province,
        city: addr.city,
        district: addr.district,
        adcode: addr.adcode,
        address: addr.address,
        paystatus: 0,
        deliverstatus: 0,
        receivestatus: 0,
        evaluatestatus: 0,
        afterstatus: 0,
        summary: params[:summary],
        amount: 0,
        profit: 0,
        shop_id: shop_id
    )
    amount = 0
    if params[:chooseproprice].to_i == 1
      buycars.each do |f|
        order.orderdetails.create(product_id: f.product_id, number: f.number, price: f.proprice)
        amount += f.number * f.proprice
      end
    else
      buycars.each do |f|
        order.orderdetails.create(product_id: f.product_id, number: f.number, price: f.price)
        amount += f.number * f.price
      end
    end
    order.update(amount: amount)
    user.buycars.destroy_all
    #PayafterJob.perform_later(order.id)
    #PaybeforeJob.perform_later(order.id)
    development_payafter(order.id)
    return_api('')
  end

  def getorders
    user = User.find_by_token(params[:token])
    collection = ['adcode = 000000']
    if params[:ordertype].include?('pay')
      #orders = user.orders.where('paystatus = ?', 0).order('id desc')
      collection.push '(paystatus = 0)'
    elsif params[:ordertype].include?('deliver')
      #orders = user.orders.where('paystatus = ? and deliverstatus = ?', 1, 0).order('id desc')
      collection.push '(paystatus = 1 and deliverstatus = 0)'
    elsif params[:ordertype].include?('receive')
      #orders = user.orders.where('deliverstatus = ? and receivestatus = ?', 1, 0).order('id desc')
      collection.push '(deliverstatus = 1 and receivestatus = 0)'
    elsif params[:ordertype].include?('evaluate')
      #orders = user.orders.where('receivestatus = ? and evaluatestatus = ?', 1, 0).order('id desc')
      collection.push '(receivestatus = 1 and evaluatestatus = 0)'
    elsif params[:ordertype].include?('finish')
      #orders = user.orders.where('evaluatestatus = ?', 1).order('id desc')
      collection.push 'evaluatestatus = 1'
    elsif params[:ordertype].include?('after')
      #orders = user.orders.where('afterstatus = ?', 1).order('id desc')
      collection.push 'afterstatus = 1'
    end
    orders = user.orders.where(collection.join(' or ')).order('id desc')
    orderarr = []
    orders = orders.page(params[:page]).per(10)
    final = 0
    final = 1 if orders.last_page? || orders.out_of_range?
    orders.each do |order|
      orderdetailarr = []
      orderdetails = order.orderdetails
      orderdetails.each do |orderdetail|
        product = orderdetail.product
        orderdetail_param = {
            orderdetail_id: orderdetail.id,
            name: product.name,
            price: product.price,
            number: orderdetail.number,
            cover: product.cover
        }
        orderdetailarr.push orderdetail_param
      end
      shopname = ''
      shop = Shop.find_by(id: order.shop_id)
      if shop
        shopname = shop.name
      end
      order_param = {
          order_id: order.id,
          ordernumber: order.ordernumber,
          ordersum: order.amount,
          aftertype: order.afterstatus.to_i,
          orderdetails: orderdetailarr,
          shop: shopname
      }
      orderarr.push order_param
    end
    param = {
        orders: orderarr,
        final: final
    }
    return_api(param)
  end

  private

  def development_payafter(orderid)
    order = Order.find(orderid)
    order.update(paystatus: 1, paytime: Time.now)
    PayafterJob.perform_later(order.id)
    ReceiveafterJob.set(wait: 1.minutes).perform_later(orderid)
  end
end

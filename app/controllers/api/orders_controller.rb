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
    pa_amount = 0
    if params[:chooseproprice].to_i == 1
      buycars.each do |f|
        orderdetail = order.orderdetails.create(product_id: f.product_id, number: f.number, price: f.proprice)
        f.buycarparams.each do |bp|
          orderdetail.orderdetailparams.create(buyparam: bp.buyparam, buyparam_id: bp.buyparam_id, buyparamvalue: bp.buyparamvalue, buyparamvalue_id: bp.buyparamvalue_id)
        end
        amount += f.number * f.proprice
      end
    else
      buycars.each do |f|
        orderdetail = order.orderdetails.create(product_id: f.product_id, number: f.number, price: f.price)
        f.buyarparams.each do |bp|
          orderdetail.orderdetailparams.create(buyparam: bp.buyparam, buyparam_id: bp.buyparam_id, buyparamvalue: bp.buyparamvalue, buyparamvalue_id: bp.buyparamvalue_id)
        end
        amount += f.number * f.price
      end
    end

    order.update(amount: amount)
    #发票
    if params[:invoice_id] && params[:invoice_id].to_i != 0
      invoicedef = Invoicedef.find(params[:invoice_id])
      order.create_orderinvoice(
          name: invoicedef.name,
          duty: invoicedef.duty,
          address: invoicedef.address,
          tel: invoicedef.tel,
          bank: invoicedef.bank,
          account: invoicedef.account,
          mail: invoicedef.mail,
          invoicetype: invoicedef.invoicetype,
          processed: 0
      )
    end
    # 发票结束
    user.buycars.destroy_all

    DeletestayorderJob.set(wait: 2.hours).perform_later(order.id)
    #development_payafter(order.id)
    param = {
        order_id: order.id
    }
    return_api(param)
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
    if params[:ordertype].include?('pay')
      orders = orders.where('created_at > ?', Time.now - 1.hours)
    end
    orderarr = []
    orders = orders.page(params[:page]).per(10)
    final = 0
    final = 1 if orders.last_page? || orders.out_of_range?
    orders.each do |order|
      orderdetailarr = []
      orderdetails = order.orderdetails
      orderdetails.each do |orderdetail|
        product = orderdetail.product
        cover = product.cover
        orderdetail.orderdetailparams.each do |op|
          buyparamvalue = Buyparamvalue.find_by(id: op.buyparamvalue_id)
          if buyparamvalue && buyparamvalue.cover.to_s.size > 0
            cover = buyparamvalue.cover
          end
        end
        orderdetail_param = {
            orderdetail_id: orderdetail.id,
            name: product.name,
            price: orderdetail.price,
            number: orderdetail.number,
            cover: cover,
            buyparams: orderdetail.orderdetailparams.map{|n|n.buyparam + ' ' + n.buyparamvalue}.join(' ')
        }
        orderdetailarr.push orderdetail_param
      end
      shopname = ''
      shop = Shop.find_by(id: order.shop_id)
      if shop
        shopname = shop.name
      end
      deletetxt = ((order.created_at + 1.hours - Time.now).to_i / 60 + 1).to_s + '分钟后自动删除'
      order_param = {
          order_id: order.id,
          ordernumber: order.ordernumber,
          ordersum: order.amount,
          aftertype: order.afterstatus.to_i,
          orderdetails: orderdetailarr,
          shop: shopname,
          deletetxt: deletetxt
      }
      orderarr.push order_param
    end
    param = {
        orders: orderarr,
        final: final
    }
    return_api(param)
  end

  def deleteorder
    order = Order.find(params[:orderid])
    if order.paystatus.to_i == 0
      order.destroy
    end
    return_api('')
  end

  private

  def development_payafter(orderid)
    order = Order.find(orderid)
    order.update(paystatus: 1, paytime: Time.now)
    orderdetails = order.orderdetails
    orderdetails.each do |orderdetail|
      product = orderdetail.product
      product.update(salecount: product.salecount.to_i + orderdetail.number)
    end
    PayafterJob.perform_later(order.id)
    ReceiveafterJob.set(wait: 1.minutes).perform_later(orderid)
  end
end

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

  def show
    order = Order.find(params[:id])
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
    order_param = {
        ordernumber: order.ordernumber,
        state: state,
        paytime: order.paytime ? order.paytime.strftime('%Y-%m-%d %H:%M:%S') : '',
        contact: order.contact,
        contactphone: order.contactphone,
        amount: order.amount.to_s(:currency,unit:''),
        address: order.province.to_s + order.city.to_s + order.district.to_s + order.address.to_s,
        summary: order.summary.to_s
    }
    orderarr= [
        {value1:'订单编号', value2:order_param[:ordernumber], value3: '订单状态', value4: order_param[:state]},
        {value1:'订单金额', value2:order_param[:amount], value3: '支付时间', value4: order_param[:paytime]},
        {value1:'收货人', value2:order_param[:contact], value3: '收货电话', value4: order_param[:contactphone]},
        {value1:'收货地址', value2:order_param[:address], value3: '', value4: ''},
        {value1:'备注', value2:order_param[:summary], value3: '', value4: ''},
    ]
    orderdetails = order.orderdetails
    orderdetailarr = []
    orderdetails.each do |f|
    orderdetail_param = {
        product: f.product.name,
        number: f.number,
        price: f.price.to_s(:currency, unit:''),
        pricesum: (f.number * f.price).to_s(:currency, unit: '')
    }
    orderdetailarr.push orderdetail_param
    end
    orderdelivers = order.orderdelivers
    orderdeliverarr = []
    orderdelivers.each do |f|
      state = '未知'
      if f.state.to_s.size > 0
        state = '在途' if f.state.to_i == 0
        state = '揽收' if f.state.to_i == 1
        state = '疑难' if f.state.to_i == 2
        state = '签收' if f.state.to_i == 3
        state = '退签' if f.state.to_i == 4
        state = '派件' if f.state.to_i == 5
        state = '退回' if f.state.to_i == 6
        state = '转投' if f.state.to_i == 7
        state = '待清关' if f.state.to_i == 10
        state = '清关中' if f.state.to_i == 11
        state = '已清关' if f.state.to_i == 12
        state = '清关异常' if f.state.to_i == 13
        state = '拒签' if f.state.to_i == 14
      end
      orderdeliver_param = {
          id: f.id,
          nu: f.nu,
          company: f.company,
          cdata: f.cdata,
          state: state
      }
      orderdeliverarr.push orderdeliver_param
    end
    param = {
        order: orderarr,
        orderdetails: orderdetailarr,
        orderdelivers: orderdeliverarr
    }
    return_res(param)
  end

  def judge_express
    nu = params[:nu]
    nu.tr!('，', ' ')
    nu.tr!(',', ' ')
    num = nu.split(' ')
    num.uniq!
    order = Order.find(params[:orderid])
    num.each do |f|
      if f.size > 0
        com = Backrun.judge_express(f)
        com = com[0]["comCode"]
        expresscode = Expresscode.find_by_comcode(com)
        orderdeliver = order.orderdelivers.create(com: expresscode.comcode, nu: f, company: expresscode.name)
        get_deliverdetail(orderdeliver.id, expresscode.comcode, f)
        poll_deliver(expresscode.comcode, f)
      end
    end
    order.update(deliverstatus: 1, delivertime: Time.now)
    AutoreceiveJob.set(wait: Setting.first.autoreceive.days).perform_later(order.id)
    AutoevaluateJob.set(wait: Setting.first.autoevaluate.days).perform_later(order.id)
    res_name = order.orderdelivers.map(&:company)
    res_name.uniq!
    return_res(res_name.join(' '))
  end

  def deletedeliver
    data = JSON.parse(params[:data])
    orderdeliver = Orderdeliver.find(data["id"])
    orderdeliver.destroy
    return_res('')
  end

  private

  def get_deliverdetail(orderdeliverid, com, num)
    pa = {
        com: com,
        num: num
    }
    sign =  Digest::MD5.hexdigest(pa.to_json +  'oWhaBhKc3008' + '33BF8AE418809366438B75CDD747B10B').upcase
    conn = Faraday.new(:url => 'https://poll.kuaidi100.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:customer] = '33BF8AE418809366438B75CDD747B10B'
    conn.params[:sign] = sign
    conn.params[:param] = pa.to_json
    request = conn.post do |req|
      req.url '/poll/query.do'
    end
    od = JSON.parse(request.body)
    begin
      cdata = od["data"].to_json
      orderdeliver = Orderdeliver.find(orderdeliverid)
      orderdeliver.update(state: od["state"], cdata: cdata)
    rescue
    end
  end

  def poll_deliver(com, num)
    pa = {
        company: com,
        number: num,
        key: 'oWhaBhKc3008',
        parameters:{
            callbackurl: 'https://coffee.ysdsoft.com/polldeliver'
        }
    }
    conn = Faraday.new(:url => 'https://poll.kuaidi100.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:schema] = 'json'
    conn.params[:param] = pa.to_json
    request = conn.post do |req|
      req.url '/poll'
    end
  end
end

class Api::UsersController < ApplicationController
  def getuserinfo
    user = User.find_by_token(params[:token])
    businetype = ''
    examine = user.examines.last
    if examine
      agentlevel = examine.agentlevel
      businetype = agentlevel.name if agentlevel.frontdisplay == 1
    end
    ispro = 0
    shopusers = user.shopusers.where('member <> ?', 0)
    ispro = 1 if shopusers.size > 0
    shopids = shopusers.map(&:shop_id)
    shoudan = 0
    shopids.each do |f|
      orders = Order.where(shop_id:f)
      if orders.size == 0
        shoudan = 1
        break
      end
    end
    shopdefaultid = 0
    defaultshop = Shop.where(id: shopusers.map(&:shop_id))
    if defaultshop.size > 0
      if user.shopdefaultid.to_i == 0
        shopdefaultid = defaultshop.first.id
        user.update(shopdefaultid: shopdefaultid)
      else
        shopdefaultid = user.shopdefaultid
      end
    end

    draftuser = user.shopusers.where(member: 0)
    contractdraftcount = Shop.where('id in (?) and created_at > ? and contractstatus = ?', draftuser.map(&:shop_id) + [0], Time.now - 1.days, 0).size
    user_param = {
        id: user.id,
        openId: user.openid.to_s,
        nickName: user.nickname.to_s,
        avatarUrl: user.headurl.to_s,
        token: user.token.to_s,
        addressSize: user.receiveaddrs.size,
        paycount: user.orders.where('paystatus = ? and created_at > ?', 0, Time.now - 1.hours).size,
        delivercount: user.orders.where('paystatus = ? and deliverstatus = ?', 1, 0).size,
        receivecount: user.orders.where('deliverstatus = ? and receivestatus = ?', 1, 0).size,
        evaluatecount: user.orders.where('receivestatus = ? and evaluatestatus = ?', 1, 0).size,
        ispro: ispro,
        businetype: businetype,
        stayincome: user.incomes.where('status = ?', 0).sum('amount').round(2),
        income: user.incomes.where('status = ?', 1).sum('amount').round(2),
        canwithdraw: (user.incomes.where('status = ?', 1).sum('amount') - user.withdrawals.where(status: 1).sum('amount')).round(2),
        shopdefaultid: shopdefaultid,
        shoudan: shoudan,
        contractdraftcount: contractdraftcount
    }
    receiveaddr = user.receiveaddrs.order('updated_at desc').first
    if receiveaddr
      currentaddress = {
          id: receiveaddr.id,
          contact: receiveaddr.contact,
          contactphone: receiveaddr.contactphone,
          province: receiveaddr.province,
          city: receiveaddr.city,
          district: receiveaddr.district,
          address: receiveaddr.address,
          adcode: receiveaddr.adcode,
      }
    else
      currentaddress = ''
    end
    defaultinvoice = {}
    invoicedef = user.invoicedefs.where(isdefault: 1).first
    if invoicedef
      defaultinvoice = {
          id: invoicedef.id,
          name: invoicedef.name,
          invoicetype: invoicedef.invoicetype == 1 ? '增值税普通发票' : '增值税专用发票'
      }
    end
    param = {
        user: user_param,
        currentaddress: currentaddress,
        defaultinvoice: defaultinvoice
    }
    return_api(param)
  end

  def getaddrs
    user = User.find_by_token(params[:token])
    receiveaddrs = user.receiveaddrs.order('updated_at desc')
    receiveaddrarr = []
    receiveaddrs.each do |f|
      addr_param = {
          id: f.id,
          contact: f.contact,
          contactphone: f.contactphone,
          province: f.province,
          city: f.city,
          district: f.district,
          address: f.address,
          adcode: f.adcode
      }
      receiveaddrarr.push addr_param
    end
    return_api(receiveaddrarr)
  end

  def getaddr
    receiveaddr = Receiveaddr.find(params[:addr_id])
    currentaddress = {
        id: receiveaddr.id,
        contact: receiveaddr.contact,
        contactphone: receiveaddr.contactphone,
        province: receiveaddr.province,
        city: receiveaddr.city,
        district: receiveaddr.district,
        address: receiveaddr.address,
        adcode: receiveaddr.adcode
    }
    return_api(currentaddress)
  end

  def createaddr
    user = User.find_by_token(params[:token])
    user.receiveaddrs.create(
        province: params[:area][0],
        city: params[:area][1],
        district: params[:area][2],
        adcode: params[:adcode],
        contact: params[:contact],
        contactphone: params[:contactphone],
        address: params[:address]
    )
    return_api('')
  end

  def updateaddr
    receiveaddr = Receiveaddr.find(params[:addr_id])
    receiveaddr.update(
        province: params[:area][0],
        city: params[:area][1],
        district: params[:area][2],
        adcode: params[:adcode],
        contact: params[:contact],
        contactphone: params[:contactphone],
        address: params[:address]
    )
    return_api('')
  end

  def deleteaddr
    receiveaddr = Receiveaddr.find(params[:addr_id])
    receiveaddr.destroy
    return_api('')
  end
end

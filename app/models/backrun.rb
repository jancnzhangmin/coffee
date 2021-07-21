class Backrun
  def self.pay(orderid)
    order = Order.find(orderid)
    order.update(paystatus: 1, paytime: Time.now)
  end

  def self.teamupgrade(userid) #团队升级
    user = User.find(userid)
    if user.examines.size == 0
      agentlevel = Agentlevel.find_by_businetype('man')
      user.examines.create(agentlevel_id: agentlevel.id, examinedate: Time.now + 6.months, checkexamine: 0)
    else
      agentlevel = user.examines.last.agentlevel
      if agentlevel.businetype == 'man'
        #ordersize = cal_order_size(user.id)
        ordersize = 0
        childrens = user.childrens
        childrens.each do |f|
          if cal_upgrade_order_size(f.id)
            ordersize += 1
          end
        end
        if ordersize > 14
          temagentlevel = Agentlevel.find_by_businetype('director')
          user.examines.create(agentlevel_id: temagentlevel.id, examinedate: Time.now + 6.months, checkexamine: 0)
        end
      elsif agentlevel.businetype == 'director'
        childrens = user.childrens
        lcount = 0
        childrens.each do |f|
          if cal_upgrade_character_size(f.id, 'director')
            lcount += 1
          end
        end
        if lcount > 2
          temagentlevel = Agentlevel.find_by_businetype('manager')
          user.examines.create(agentlevel_id: temagentlevel.id, examinedate: Time.now + 6.months, checkexamine: 0)
        end
      elsif agentlevel.businetype == 'manager'
        childrens = user.childrens
        lcount = 0
        childrens.each do |f|
          if cal_upgrade_character_size(f.id, 'manager')
            lcount += 1
          end
        end
        if lcount > 2
          temagentlevel = Agentlevel.find_by_businetype('partner')
          user.examines.create(agentlevel_id: temagentlevel.id, examinedate: Time.now + 6.months, checkexamine: 0)
        end
      end
    end
    parent = user.parent
    if parent
      teamupgrade(parent.id)
    end
  end

  def self.cal_upgrade_order_size(userid) #计算升级条件订单
    user = User.find(userid)
    ordersize = user.orders.where("paystatus = ? and paytime > ?", 1, Time.now - 6.month).size
    res = false
    if ordersize > 0
      res = true
    else
      childrens = user.childrens
      childrens.each do |f|
        res ||= cal_upgrade_order_size(f.id)
      end
    end
    res
  end

  def self.cal_upgrade_character_size(userid, character) #计算升级角色条件
    user = User.find(userid)
    agentlevel = user.examines.last.agentlevel
    res = false
    if agentlevel.businetype == character
      res = true
    else
      childrens = user.childrens
      childrens.each do |f|
        res ||= cal_upgrade_character_size(f.id, character)
      end
    end
    res
  end

  def self.fibo1(n)
    if n==1 or n==2
      return 1;
    end
    fibo1(n-1)
  end

  def self.cal_distribute(orderid) #计算分销利润
    order = Order.find(orderid)
    user = order.user
    parent = user.parent
    if parent
      amount = Setting.first.firstprofit.to_f * order.amount.to_f / 100
      if amount > 0
        parent.incomes.create(amount: amount, ordernumber: order.ordernumber, status: 0, summary: user.nickname.to_s + '分销收入',profittype: 'distribute')
      end
      parent_parent = parent.parent
      if parent_parent
        amount = Setting.first.secondprofit.to_f * order.amount.to_f / 100
        parent_parent.incomes.create(amount: amount, ordernumber: order.ordernumber, status: 0, summary: user.nickname.to_s + '分销收入',profittype: 'distribute')
      end
    end
  end

  def self.cal_teamprofit(orderid, userid = 0, amount = 0, amountsum = 0) #计算团队收入
    order = Order.find(orderid)
    user = order.user
    orderuser = order.user
    user = User.find(userid) if userid != 0
    examine = user.examines.last
    agentlevel = examine.agentlevel
    temamount = order.amount.to_f * agentlevel.profitratio.to_f / 100
    if temamount > amountsum && userid != 0
      amountsum = temamount
      amount = temamount - amount
      user.incomes.create(amount: amount, ordernumber: order.ordernumber, status: 0, summary: orderuser.nickname.to_s + '团队收入',profittype: 'team')
    end
    parent = user.parent
    if parent
      cal_teamprofit(orderid, parent.id, amount, amountsum)
    end
  end

  def self.cal_rebate(orderid, currentuserid = 0, parentuserid = 0, agentlevelid = 0) #计算同级返点
    order = Order.find(orderid)
    if agentlevelid == 0
      currentuser = order.user
      parentuser = currentuser.parent
      agentlevel = currentuser.examines.last.agentlevel
    else
      agentlevel = Agentlevel.find(agentlevelid)
      currentuser = User.find(currentuserid)
      parentuser = User.find(parentuserid)
    end

    if currentuser && parentuser && currentuser.examines.last.agentlevel_id == agentlevel.id && parentuser.examines.last.agentlevel_id == agentlevel.id
      amount = order.amount.to_f * agentlevel.rebate.to_f / 100
      if amount > 0
        parentuser.incomes.create(amount: amount, ordernumber: order.ordernumber, status: 0, summary: currentuser.nickname.to_s + '同级返点',profittype: 'rebate')
      end
      agentlevel = Agentlevel.where('corder > ?', agentlevel.corder).order('corder').first
      currentuser = order.user
      parentuser = currentuser.parent
    else
      if parentuser
        parentuser = parentuser.parent
      end
    end

    if !parentuser
      currentuser = currentuser.parent
      if  currentuser
        parentuser = currentuser.parent
        if !parentuser
          agentlevel = Agentlevel.where('corder > ?', agentlevel.corder).order('corder').first
          currentuser = order.user
          parentuser = currentuser.parent
        end
      end
    end

    if currentuser && parentuser && agentlevel
      cal_rebate(orderid, currentuser.id, parentuser.id, agentlevel.id)
    end
  end

  def self.cal_profit(orderid) #计算订单利润
    order = Order.find(orderid)
    profit = Income.where('ordernumber = ?', order.ordernumber).sum('amount')
    cost = 0
    orderdetails = order.orderdetails
    orderdetails.each do |f|
      product = f.product
      cost += f.number * product.cost
    end
    profit = order.amount - profit - cost
    order.update(profit: profit)
  end

  def self.cal_order_size(userid, ordersize = 0) #计算团队订单量
    user = User.find(userid)
    ordersize = user.orders.where('paystatus = ?', 1).size
    childrens = user.childrens
    childrens.each do |f|
      ordersize += cal_order_size(f.id, ordersize)
    end
    ordersize
  end

  def self.cal_cycle_order_size(userid, begintime, endtime, ordersize = 0) #计算团队区间订单量
    user = User.find(userid)
    ordersize = user.orders.where('paystatus = ? and paytime between ? and ?', 1, begintime, endtime).size
    childrens = user.childrens
    childrens.each do |f|
      ordersize += cal_cycle_order_size(f.id, begintime, endtime, ordersize)
    end
    ordersize
  end

  def self.judge_express(num) #识别快递公司
    conn = Faraday.new(:url => 'http://www.kuaidi100.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:num] = num
    conn.params[:key] = Setting.first.kuaidikey
    request = conn.post do |req|
      req.url '/autonumber/auto'
    end
    JSON.parse(request.body)
  end

  def self.cal_cycle_sale(userid, begintime, endtime, salecount = 0) #计算团队销售
    user = User.find(userid)
    salecount = user.orders.where('paystatus = ? and paytime between ? and ?', 1, begintime, endtime).sum('amount')
    childrens = user.childrens
    childrens.each do |f|
      salecount += cal_cycle_sale(f.id, begintime, endtime, salecount)
    end
    salecount
  end

  def self.cal_shoudan(userid, shoudan, chooseproprice, shopid)
    if shoudan != 0 && chooseproprice != 0 && shopid != 0
      user = User.find(userid)
      buycars = user.buycars.where('producttype = ?', 0)
      shopfirsts = Shopfirst.where('status = ? and begintime <= ? and endtime >= ?', 1, Time.now, Time.now)
      shopfirsts.each do |shopfirst|
        shopfirstdetails = shopfirst.shopfirstdetails
        shopfirstdetails.each do |shopfirstdetail|
          buycarproduct = buycars.find_by(product_id: shopfirstdetail.buyproduct_id)
          if buycarproduct && buycarproduct.number >= shopfirstdetail.buynumber
            giveproduct = Product.find(shopfirstdetail.giveproduct_id)
            user.buycars.create(product_id: shopfirstdetail.giveproduct_id, number: (buycarproduct.number / shopfirstdetail.buynumber).to_i, price: giveproduct.price, proprice: 0, producttype: 1, activesummary: shopfirst.name)
          end
        end
      end
    end
  end

  def self.shop_buysum(orderid)
    order = Order.find(orderid)
    shop = Shop.find_by(id:order.shop_id)
    if shop && order.shop_id.to_i != 0
      buysum = Order.where(shop_id: shop.id, paystatus: 1).sum('amount')
      shop.update(buysum: buysum, lastbuytime: order.paytime)
    end
  end

  def self.payafter(orderid)
    order = Order.find(orderid)
    incomes = Income.where(ordernumber: order.ordernumber)
    incomes.each do |f|
      f.update(status: 1)
    end
  end

  def self.get_accesstoken
    if !Accesstoken.first
      accesstoken = refresh_accesstoken
    elsif Accesstoken.first.created_at.to_i + Accesstoken.first.expiresin - 10 < Time.now.to_i
      accesstoken = refresh_accesstoken
    else
      accesstoken = Accesstoken.first.accesstoken
    end
    accesstoken
  end

  def self.refresh_accesstoken
    conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:grant_type] = 'client_credential'
    conn.params[:appid] = Setting.first.appid
    conn.params[:secret] = Setting.first.appsecret.to_s
    request = conn.get do |req|
      req.url '/cgi-bin/token'
    end
    data = JSON.parse(request.body)
    Accesstoken.all.destroy_all
    Accesstoken.create(accesstoken: data["access_token"], expiresin: data["expires_in"])
    data["access_token"]
  end


end
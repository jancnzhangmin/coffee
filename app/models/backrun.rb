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
        ordersize = cal_order_size(user.id)
        if ordersize > 14
          temagentlevel = Agentlevel.find_by_businetype('director')
          user.examines.create(agentlevel_id: temagentlevel.id, examinedate: Time.now + 6.months, checkexamine: 0)
        end
      elsif agentlevel.businetype == 'director'
        childrens = user.childrens
        lcount = 0
        agentlevelcorder = agentlevel.corder
        childrens.each do |f|
          examine = f.examines.last
          if examine
            temagentlevel = examine.agentlevel
            if temagentlevel.corder >= agentlevelcorder
              lcount += 1
            end
          end
        end
        if lcount > 2
          temagentlevel = Agentlevel.find_by_businetype('manager')
          user.examines.create(agentlevel_id: temagentlevel.id, examinedate: Time.now + 6.months, checkexamine: 0)
        end
      elsif agentlevel.businetype == 'manager'
        childrens = user.childrens
        lcount = 0
        agentlevelcorder = agentlevel.corder
        childrens.each do |f|
          examine = f.examines.last
          if examine
            temagentlevel = examine.agentlevel
            if temagentlevel.corder >= agentlevelcorder
              lcount += 1
            end
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

  def self.cal_teamprofit(orderid, userid = 0, amount = 0) #计算团队收入
    order = Order.find(orderid)
    user = order.user
    user = User.find(userid) if userid != 0
    examine = user.examines.last
    agentlevel = examine.agentlevel
    temamount = order.amount.to_f * agentlevel.profitratio.to_f / 100
    if temamount > amount
      amount = temamount - amount
      user.incomes.create(amount: amount, ordernumber: order.ordernumber, status: 0, summary: user.nickname.to_s + '团队收入',profittype: 'team')
    end
    parent = user.parent
    if parent
      cal_teamprofit(orderid, parent.id, amount)
    end
  end

  def self.cal_rebate(orderid, userid = 0) #计算同级返点
    order = Order.find(orderid)
    user = order.user
    user = User.find(userid) if userid != 0
    parent = user.parent
    if parent
      userexamine = user.examines.last
      parentexamine = parent.examines.last
      if userexamine && parentexamine
        useragentlevel = userexamine.agentlevel
        parentagentlevel = parentexamine.agentlevel
        if parentagentlevel.corder == useragentlevel.corder
          amount = order.amount.to_f * parentagentlevel.rebate.to_f / 100
          if amount > 0
            parent.incomes.create(amount: amount, ordernumber: order.ordernumber, status: 0, summary: user.nickname.to_s + '同级返点',profittype: 'rebate')
          end
        end
      end
      cal_rebate(orderid, parent.id)
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

  def self.cal_order_size(userid, ordersize = 0)
    user = User.find(userid)
    ordersize = user.orders.where('paystatus = ?', 1).size
    childrens = user.childrens
    childrens.each do |f|
      ordersize += cal_order_size(f.id, ordersize)
    end
    ordersize
  end

end
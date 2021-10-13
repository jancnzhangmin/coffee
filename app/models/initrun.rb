class Initrun
  def self.init_evaluate #初始化商品评价
    products = Product.all
    products.each do |f|
      if f.evaluates.size > 0
        speed = f.evaluates.average('speed').to_f
        quality = f.evaluates.average('quality').to_f
        describe = f.evaluates.average('describe').to_f
        comp = (speed + quality + describe) / 3
      else
        speed = 5
        quality = 5
        describe = 5
        comp = 5
      end
      f.update(speed: speed, quality: quality, describe: describe, comp: comp)
    end
  end

  def self.init_team #初始化团队人数
    users = User.all
    users.each do |user|
      user.update(
          salesum: get_year_salesum(user.id),
          salecount: get_year_salecount(user.id),
          peoplecount: get_peoplecount(user.id),
          mancount: get_businecount(user.id, user.id, 'man'),
          directorcount: get_businecount(user.id, user.id, 'director'),
          managercount: get_businecount(user.id, user.id,'manager'),
          )
    end
  end

  def self.init_teamorderid #初始化团队订单id
    users = User.all
    users.each do |user|
      orderids = cal_orderids(user.id)
      Teamorderid.transaction do
        teamouderids = user.teamorderids
        teamouderids.destroy_all
        orderids.each do |orderid|
          user.teamorderids.create(order_id: orderid)
        end
      end
    end
  end

  def self.simulate_pay(orderid) #模拟支付
    order = Order.find_by(id: orderid)
    if order && order.paystatus.to_i == 0
      order.update(paystatus: 1, paytime: Time.now)
      orderdetails = order.orderdetails
      orderdetails.each do |orderdetail|
        product = orderdetail.product
        product.update(salecount: product.salecount.to_i + orderdetail.number)
      end
      PayafterJob.perform_later(order.id)
    end
  end

  private

  def self.get_year_salesum(userid, yearsum = 0)
    user = User.find(userid)
    yearsum = user.orders.where('paystatus = ? and created_at between ? and ?', 1, Time.now - 1.years, Time.now).sum('amount')
    childrens = user.childrens
    childrens.each do |f|
      yearsum += get_year_salesum(f.id, yearsum)
    end
    yearsum
  end

  def self.get_year_salecount(userid, yearcount = 0)
    user = User.find(userid)
    yearcount = user.orders.where('paystatus = ? and created_at between ? and ?', 1, Time.now - 1.years, Time.now).size
    childrens = user.childrens
    childrens.each do |f|
      yearcount += get_year_salecount(f.id, yearcount)
    end
    yearcount
  end

  def self.get_peoplecount(userid, pcount = 0)
    user = User.find(userid)
    childrens = user.childrens
    pcount = childrens.size
    childrens.each do |f|
      pcount += get_peoplecount(f.id, pcount)
    end
    pcount
  end

  def self.get_businecount(userid, selfid, businetype, pcount = 0)
    user = User.find(userid)
    agentlevel = Agentlevel.find_by_businetype(businetype)
    if user.examines.last.agentlevel_id == agentlevel.id && userid != selfid
      pcount = 1
    else
      pcount = 0
    end
    childrens = user.childrens
    childrens.each do |f|
      pcount += get_businecount(f.id, selfid, businetype, pcount)
    end
    pcount
  end

  def self.cal_orderids(userid, orderids = [])
    user = User.find(userid)
    childrens = user.childrens
    orderids = user.orders.ids
    childrens.each do |f|
      orderids += cal_orderids(f.id, orderids)
    end
    orderids
  end
end
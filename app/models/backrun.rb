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
        # ordersize = 0
        # childrens = user.childrens
        # childrens.each do |f|
        #   if cal_upgrade_order_size(f.id)
        #     ordersize += 1
        #   end
        # end
        ordersize = Order.where('paytime between ? and ? and id in(?)', Time.now - 6.month, Time.now, user.teamorderids.map(&:order_id) - user.orders.ids + [0]).size
        if ordersize > 14
          temagentlevel = Agentlevel.find_by_businetype('director')
          user.examines.create(agentlevel_id: temagentlevel.id, examinedate: Time.now + 6.months, checkexamine: 0)
          parent = user.parent
          if parent
            parent.update(mancount: parent.mancount.to_i - 1, directorcount: parent.directorcount.to_i + 1)
          end
        end
      elsif agentlevel.businetype == 'director'
        # childrens = user.childrens
        # lcount = 0
        # childrens.each do |f|
        #   if cal_upgrade_character_size(f.id, 'director')
        #     lcount += 1
        #   end
        # end
        lcount = user.directorcount.to_i
        if lcount > 2
          temagentlevel = Agentlevel.find_by_businetype('manager')
          user.examines.create(agentlevel_id: temagentlevel.id, examinedate: Time.now + 6.months, checkexamine: 0)
          parent = user.parent
          if parent
            parent.update(directorcount: parent.directorcount.to_i - 1, managercount: parent.managercount.to_i + 1)
          end
        end
      elsif agentlevel.businetype == 'manager'
        #childrens = user.childrens
        # lcount = 0
        # childrens.each do |f|
        #   if cal_upgrade_character_size(f.id, 'manager')
        #     lcount += 1
        #   end
        # end
        lcount = user.managercount.to_i
        if lcount > 2
          temagentlevel = Agentlevel.find_by_businetype('partner')
          user.examines.create(agentlevel_id: temagentlevel.id, examinedate: Time.now + 6.months, checkexamine: 0)
          parent = user.parent
          if parent
            parent.update(managercount: parent.managercount.to_i - 1)
          end
        end
      end
    end
    parent = user.parent
    if parent
      teamupgrade(parent.id)
    end
  end

  def self.add_parent_orderid(orderid, userid) #增加父级订单id
    user = User.find(userid)
    user.teamorderids.create(order_id: orderid)
    parent = user.parent
    if parent
      add_parent_orderid(orderid, parent.id)
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
        data = {
            touser: parent.openid,
            template_id: "oTv6Jpg8BABDeDOa2uSdBrceEmj239AEzi_ZcVDmmxk",
            miniprogram: {
                appid: Setting.first.appid,
                path: "index"
            },
            data: {
                first: {
                    value: "团队用户成功下单",
                },
                keyword1: {
                    value: order.ordernumber,
                },
                keyword2: {
                    value: order.amount.to_s(:currency, unit:''),
                },
                keyword3: {
                    value: amount.to_s(:currency, unit: '')
                },
                remark: {
                    value: "",
                }
            }
        }
        SendmpmsgJob.perform_later(parent.id, data.to_json)
      end
      parent_parent = parent.parent
      if parent_parent
        amount = Setting.first.secondprofit.to_f * order.amount.to_f / 100
        parent_parent.incomes.create(amount: amount, ordernumber: order.ordernumber, status: 0, summary: user.nickname.to_s + '分销收入',profittype: 'distribute')
        data = {
            touser: parent_parent.openid,
            template_id: "oTv6Jpg8BABDeDOa2uSdBrceEmj239AEzi_ZcVDmmxk",
            miniprogram: {
                appid: Setting.first.appid,
                path: "index"
            },
            data: {
                first: {
                    value: "团队用户成功下单",
                },
                keyword1: {
                    value: order.ordernumber,
                },
                keyword2: {
                    value: order.amount.to_s(:currency, unit:''),
                },
                keyword3: {
                    value: amount.to_s(:currency, unit: '')
                },
                remark: {
                    value: "",
                }
            }
        }
        SendmpmsgJob.perform_later(parent_parent.id, data.to_json)
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
      data = {
          touser: user.openid,
          template_id: "oTv6Jpg8BABDeDOa2uSdBrceEmj239AEzi_ZcVDmmxk",
          miniprogram: {
              appid: Setting.first.appid,
              path: "index"
          },
          data: {
              first: {
                  value: "团队用户成功下单",
              },
              keyword1: {
                  value: order.ordernumber,
              },
              keyword2: {
                  value: order.amount.to_s(:currency, unit:''),
              },
              keyword3: {
                  value: amount.to_s(:currency, unit: '')
              },
              remark: {
                  value: "",
              }
          }
      }
      SendmpmsgJob.perform_later(user.id, data.to_json)
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
      user = f.user
      data = {
          touser: user.openid,
          template_id: "V380nofoCwjgvwYkmHaCqE3pQ0FrFttJQ6m_WggA3JM",
          miniprogram: {
              appid: Setting.first.appid,
              path: "index"
          },
          data: {
              first: {
                  value: "收益到账通知：",
              },
              keyword1: {
                  value: f.amount.to_s(:currency, unit: ''),
              },
              keyword2: {
                  value: '团队用户下单',
              },
              keyword3: {
                  value: f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
              },
              remark: {
                  value: "您的收益已到账。",
              }
          }
      }
      SendmpmsgJob.perform_later(user.id, data.to_json)
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

  def self.get_mpaccesstoken
    if !Mpaccesstoken.first
      mpaccesstoken = refresh_mpaccesstoken
    elsif Mpaccesstoken.first.created_at.to_i + Mpaccesstoken.first.expiresin.to_i - 10 < Time.now.to_i
      mpaccesstoken = refresh_mpaccesstoken
      if Mpaccesstoken.first && Mpaccesstoken.first.accesstoken.to_s.size > 0
        GetallmpuserJob.perform_later
      end
    else
      mpaccesstoken = Mpaccesstoken.first.accesstoken
    end
    mpaccesstoken
  end

  def self.refresh_mpaccesstoken
    conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:grant_type] = 'client_credential'
    conn.params[:appid] = Setting.first.mpappid
    conn.params[:secret] = Setting.first.mpappsecret
    request = conn.get do |req|
      req.url '/cgi-bin/token'
    end
    data = JSON.parse(request.body)
    Mpaccesstoken.all.destroy_all
    Mpaccesstoken.create(accesstoken: data["access_token"], expiresin: data["expires_in"])
    data["access_token"]
  end

  def self.get_all_mp_user_openid(next_openid = '') #重新获取所有用户公众号openid
    conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:access_token] = get_mpaccesstoken
    conn.params[:next_openid] = next_openid
    request = conn.get do |req|
      req.url '/cgi-bin/user/get'
    end
    data = JSON.parse(request.body)
    if !data["errcode"] && data["data"]
      mpopenids = data["data"]["openid"]
      mpopenids.each do |f|
        conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
          faraday.request :url_encoded # form-encode POST params
          faraday.response :logger # log requests to STDOUT
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
        end
        conn.params[:access_token] = get_mpaccesstoken
        conn.params[:openid] = f
        request = conn.get do |req|
          req.url '/cgi-bin/user/info'
        end
        data = JSON.parse(request.body)
        mpuser = Mpuser.find_by_openid(f)
        if !mpuser
          Mpuser.create(openid: data["openid"], unionid: data["unionid"], nickname: data["nickname"], headurl: data["headimgurl"], subscribe: data["subscribe"])
        else
          mpuser.update(subscribe: data["subscribe"])
        end
      end
      if mpopenids.size > 0
        get_all_mp_user_openid(mpopenids.last)
      end
    end
  end

  def self.get_mp_user_openid(unionid)
    openid = nil
    mpuser = Mpuser.find_by_unionid(unionid)
    if mpuser
      openid = mpuser.openid
    else
      mpuser = Mpuser.last
      next_openid = ''
      if mpuser
        next_openid = mpuser.openid
      end
      conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
        faraday.request :url_encoded # form-encode POST params
        faraday.response :logger # log requests to STDOUT
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
      conn.params[:access_token] = get_mpaccesstoken
      conn.params[:next_openid] = next_openid
      request = conn.get do |req|
        req.url '/cgi-bin/user/get'
      end
      data = JSON.parse(request.body)
      mpopenids = data["data"]["openid"]
      mpopenids.each do |f|
        conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
          faraday.request :url_encoded # form-encode POST params
          faraday.response :logger # log requests to STDOUT
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
        end
        conn.params[:access_token] = get_mpaccesstoken
        conn.params[:openid] = f
        request = conn.get do |req|
          req.url '/cgi-bin/user/info'
        end
        data = JSON.parse(request.body)
        mpuser = Mpuser.find_by_openid(f)
        if !mpuser
          Mpuser.create(openid: data["openid"], unionid: data["unionid"], nickname: data["nickname"], headurl: data["headimgurl"], subscribe: data["subscribe"])
        end
      end
      mpuser = Mpuser.find_by_unionid(unionid)
      if mpuser
        openid = mpuser.openid
      end
    end
    openid
  end

  def self.send_mp_msg(userid,data)
    begin
      user = User.find_by(id:userid)
      coverdata = JSON.parse(data)
      coverdata["touser"] = get_mp_user_openid(user.unionid)
      if user && user.unionid.to_s.size > 0
        conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
          faraday.request :url_encoded # form-encode POST params
          faraday.response :logger # log requests to STDOUT
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
        end
        conn.params[:access_token] = get_mpaccesstoken
        request = conn.post do |req|
          req.url '/cgi-bin/message/template/send'
          req.body = coverdata.to_json
        end
      end
    rescue
    end
  end

  def self.send_user_reg_msg(userid, username)
    user = User.find_by(id:userid)
    if user && user.unionid.to_s.size > 0
      mpuser_openid = get_mp_user_openid(user.unionid)
      conn = Faraday.new(:url => 'https://api.weixin.qq.com') do |faraday|
        faraday.request :url_encoded # form-encode POST params
        faraday.response :logger # log requests to STDOUT
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
      data = {
          touser: mpuser_openid,
          template_id: "2k6-0uWT7RBfEbZMLU9efcSL2TFd003i4fZGsv0Y32Y",
          miniprogram: {
              appid: Setting.first.appid,
              path: "index"
          },
          data: {
              first: {
                  value: "新用户注册成功",
              },
              keyword1: {
                  value: username,
              },
              keyword2: {
                  value: "2021-08-15 18:24:36",
              },
              remark: {
                  value: "",
              }
          }
      }
      conn.params[:access_token] = get_mpaccesstoken
      request = conn.post do |req|
        req.url '/cgi-bin/message/template/send'
        req.body = data.to_json
      end
      data = JSON.parse(request.body)
    end
  end

  def self.cal_signlediscount(userid)
    user = User.find(userid)
    buycars = user.buycars
    signlediscounts = Singlediscount.where('status = ? and begintime <= ? and endtime >= ?', 1, Time.now, Time.now)
    signlediscounts.each do |signlediscount|
      if (signlediscount.limitnewpeople.to_i == 1 && user.created_at > signlediscount.newpeopletime) || signlediscount.limitnewpeople.to_i == 0
        buycars.each do |buycar|
          if signlediscount.product_id == buycar.product_id && buycars.where(product_id: signlediscount.product_id).sum('number') >= signlediscount.buynumber
            buycar.proprice = signlediscount.discount / 100 * buycar.price
            if buycar.activesummary.to_s.size == 0
              buycar.activesummary = signlediscount.nametag
            elsif !buycar.activesummary.include?(signlediscount.nametag)
              buycar.activesummary += ' ' + signlediscount.nametag
            end
            buycar.save
            #buycar.update(proprice: signlediscount.discount / 100 * buycar.price)
          end
        end
      end
    end
  end

  def self.cal_buyfull(userid)
    user = User.find(userid)
    buyfullactives = Buyfullactive.where('status = ? and begintime <= ? and endtime >= ?', 1, Time.now, Time.now)
    buyfullactives.each do |buyfullactive|
      buycarnumber = user.buycars.where(producttype: 0, product_id: buyfullactive.product_id).sum('number')
      buyfullactivedetails = buyfullactive.buyfullactivedetails.order('buynumber desc')
      buyfullactivedetails.each do |buyfullactivedetail|
        while buycarnumber >= buyfullactivedetail.buynumber
          givebuycar = user.buycars.where(product_id: buyfullactivedetail.giveproduct_id, producttype: 1).first
          if givebuycar
            givebuycar.number += buyfullactivedetail.givenumber
            if givebuycar.activesummary.to_s.size == 0
              givebuycar.activesummary = buyfullactive.nametag
            elsif !givebuycar.activesummary.include?(buyfullactive.nametag)
              givebuycar.activesummary += ' ' + buyfullactive.nametag
            end
            givebuycar.save
          else
            giveproduct = Product.find(buyfullactivedetail.giveproduct_id)
            user.buycars.create(product_id: buyfullactivedetail.giveproduct_id, number: buyfullactivedetail.givenumber, price: giveproduct.price, proprice: 0, producttype: 1, activesummary: buyfullactive.nametag, cover: giveproduct.cover)
          end
          buycarnumber -= buyfullactivedetail.buynumber
        end
      end
    end
  end

  def self.get_product_summary(product_id, userid) #获取单品活动描述
    #buyfull 买满送活动 singlediscount 单品折扣活动
    user = User.find(userid)
    activearr = []
    buyfullactives = Buyfullactive.where('product_id = ? and begintime <= ? and endtime >= ? and status = ?', product_id, Time.now, Time.now, 1)
    buyfullactives.each do |f|
      buyfullactive_param = {
          id: f.id,
          activetype: 'buyfull',
          activename: f.name,
          activetag: f.nametag,
          summary: f.summary
      }
      activearr.push buyfullactive_param
    end
    singlediscounts = Singlediscount.where('product_id = ? and begintime <= ? and endtime >= ? and status = ?', product_id, Time.now, Time.now, 1)
    singlediscounts.each do |f|
      singlediscount_param = {
          id: f.id,
          activetype: 'singlediscount',
          activename: f.name,
          activetag: f.nametag,
          summary: f.summary
      }
      if f.limitnewpeople.to_i == 1 && user.created_at > f.newpeopletime
        activearr.push singlediscount_param
      elsif f.limitnewpeople.to_i == 0
        activearr.push singlediscount_param
      end
    end
    activearr
  end

  def self.newpeople_invitationgift(userid) #新人赠送活动
    user = User.find(userid)
    invitationgifts = Invitationgift.where('begintime <= ? and endtime >= ? and status = ? and newpeople = ?', Time.now, Time.now, 1, 1)
    invitationgifts.each do |invitationgift|
      user.giftdepots.create(
          product_id: invitationgift.product_id,
          number: 1,
          expireday: invitationgift.expireday,
          deletestatus: 0,
          usedstatus: 0,
          appointproduct_id: invitationgift.appointproduct_id,
          summary: invitationgift.nametag
      )
    end
  end

  def self.oldpeople_invitationgift(userid) #分享人赠送活动
    user = User.find(userid)
    invitationgifts = Invitationgift.where('begintime <= ? and endtime >= ? and status = ? and oldpeople = ?', Time.now, Time.now, 1, 1)
    invitationgifts.each do |invitationgift|
      user.giftdepots.create(
          product_id: invitationgift.product_id,
          number: 1,
          expireday: invitationgift.expireday,
          deletestatus: 0,
          usedstatus: 0,
          appointproduct_id: invitationgift.appointproduct_id,
          summary: invitationgift.nametag
      )
    end
  end

  def self.getgiftproduct(userid) #获取赠送商品
    user = User.find(userid)
    buycars = user.buycars
    buycararr = []
    buycars.each do |buycar|
      hasbuycar = false
      buycararr.each do |arr|
        if arr[:product_id] == buycar.product_id
          arr[:number] += buycar.number
          hasbuycar = true
          break
        end
      end
      if !hasbuycar
        buycar_param = {
            product_id: buycar.product_id,
            number: buycar.number
        }
        buycararr.push buycar_param
      end
    end
    giftdepots = user.giftdepots.where('usedstatus <> ?', 1)
    giftarr = []
    giftdepots.each do |f|
      product = Product.find(f.product_id)
      gift_param = {
          id: f.id,
          name: product.name,
          cover: product.cover,
          price: product.price,
          product_id: f.product_id,
          number: f.number,
          expireday: f.expireday,
          deletestatus: f.deletestatus,
          usedstatus: f.usedstatus,
          appointproduct_id: f.appointproduct_id,
          created_at: f.created_at,
          updated_at: f.updated_at,
          expiretime: f.created_at + f.expireday.days - Time.now,
          summary: f.summary
      }
      if gift_param[:expiretime] > 0
        giftarr.push gift_param
      end
    end
    giftarr.sort!{|a,b|a[:expiretime] <=> b[:expiretime]}
    active_product_ids = get_active_product_ids
    resultarr = []
    giftarr.each do |arr|
      if arr[:appointproduct_id]
        appointproduct = Appointproduct.find(arr[:appointproduct_id])
      else
        appointproduct = Appointproduct.first
      end
      appointproductdetails = appointproduct.appointproductdetails.where('product_id not in (?)', active_product_ids)
      buycararr.each do |buycar|
        if appointproductdetails.select{|n|buycar[:number] >= n.number && n.product_id == buycar[:product_id]}.size > 0 && arr[:expiretime] > 0
          if resultarr.select{|n|n[:id] == arr[:id]}.size == 0
            resultarr.push arr
          end
        end
      end
    end
    resultarr
  end

  def self.get_active_product_ids #获取活动商品id组
    productids = []
    singlediscounts = Singlediscount.where('status = ? and begintime <= ? and endtime >= ?', 1, Time.now, Time.now)
    productids += singlediscounts.map(&:product_id)
    buyfullactives = Buyfullactive.where('status = ? and begintime <= ? and endtime >= ?', 1, Time.now, Time.now)
    productids += buyfullactives.map(&:product_id)

    productids.uniq!
    productids += [0]
    productids
  end

  def self.gift_luckdraw_times(userid) #赠送抽奖次数
    luckdraw = Luckdraw.where('begintime <= ? and endtime >= ? and status = ?', Time.now, Time.now, 1).first
    if luckdraw
      user = User.find(userid)
      luckdrawtime = user.luckdrawtimes.where('begintime <= ? and endtime >= ?', Time.now, Time.now).first
      if luckdrawtime
        luckdrawtime.update(times: luckdrawtime.times + 1)
      else
        user.luckdrawtimes.create(begintime: luckdraw.begintime, endtime: luckdraw.endtime, systemgive: 0, times: 1)
      end
    end
  end

end
class Api::UpgradeconditionsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    examine = user.examines.last
    agentlevel = examine.agentlevel
    agentlevelname = agentlevel.name
    nextagentlevel = Agentlevel.where('corder > ?', agentlevel.corder).first
    nextagentlevelname = '无'
    nextagentlevelname = nextagentlevel.name if nextagentlevel
    upgradecondition = '无'
    upgradesit = '无'
    examinedate = '无'
    examinedate = examine.examinedate.strftime('%Y-%m-%d') if examine.examinedate
    if nextagentlevel
      childrens = user.childrens
      if nextagentlevel.businetype == 'director'
        upgradesit = '成单量 0单'
        upgradecondition = '签约15个酒店或15个部门完成下单'
        #ordercount = 0
        # childrens.each do |f|
        #   if Backrun.cal_upgrade_order_size(f.id)
        #     ordercount += 1
        #   end
        # end
        ordercount = Order.where('paytime between ? and ? and id in (?)', Time.now - 6.month, Time.now, user.teamorderids - user.orders.ids + [0])
        upgradesit = "成单量 #{ordercount}单"
      elsif nextagentlevel.businetype == 'manager'
        upgradesit = '0个业务主管'
        upgradecondition = '3个业务主管'
        # directorcount = 0
        # childrens.each do |f|
        #   if Backrun.cal_upgrade_character_size(f.id, 'director')
        #     directorcount += 1
        #   end
        # end
        directorcount = user.directorcount
        upgradesit = "#{directorcount}个业务主管"
      elsif nextagentlevel.businetype == 'partner'
        upgradesit = '0个业务经理'
        # upgradecondition = '3个业务经理'
        # directorcount = 0
        # childrens.each do |f|
        #   if Backrun.cal_upgrade_character_size(f.id, 'manager')
        #     directorcount += 1
        #   end
        # end
        directorcount = user.managercount
        upgradesit = "#{directorcount}个业务经理"
      end
    end
    param = {
        agentlevel: agentlevelname,
        nextagentlevel: nextagentlevelname,
        upgradecondition: upgradecondition,
        upgradesit: upgradesit,
        examinedate: examinedate
    }
    return_api(param)
  end
end

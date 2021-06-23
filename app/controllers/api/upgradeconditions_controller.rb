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
        directorcount = 0
        childrens.each do |f|
          if Backrun.cal_upgrade_order_size(f.id)
            directorcount += 1
          end
        end
        upgradesit = "成单量 #{directorcount}单"
      elsif nextagentlevel.businetype == 'manager'
        upgradesit = '0个部门主任'
        upgradecondition = '3个部门主任'
      elsif nextagentlevel.businetype == 'partner'
        upgradecondition = '3个部门经理'
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

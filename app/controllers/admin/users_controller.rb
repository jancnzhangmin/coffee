class Admin::UsersController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      users = User.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      users = User.all.order('id desc')
    end
    if params[:filtervalue].to_s.size > 0
      users = users.where('openid like ? or nickname like ?', "%#{params[:filtervalue]}%", "%#{params[:filtervalue]}%")
    end
    haswithdrawalcount = Withdrawal.where(status: 1).sum('amount')
    nowithdrawalcount = Income.where(status: 1).sum('amount') - haswithdrawalcount
    haswithdrawalcount = haswithdrawalcount.to_s(:currency, unit: '')
    nowithdrawalcount = nowithdrawalcount.to_s(:currency, unit: '')
    total = users.size
    users = users.page(params[:page]).per(params[:per])
    userarr = []
    users.each do |f|
      upuser = ''
      upuser = f.parent.nickname.to_s if f.parent
      upuser = f.parent.openid if f.parent && upuser.size == 0
      upuser = '无' if upuser.size == 0
      agentlevel = '业务员'
      examine = f.examines.last
      if examine
        agentlevel = examine.agentlevel.name
      end
      canwithdrawal = f.incomes.where(status: 1).sum('amount') - f.withdrawals.where(status: 1).sum('amount')
      canwithdrawal = canwithdrawal.to_s(:currency, unit: '')
      user_param = {
          id: f.id,
          headurl: f.headurl.to_s,
          nickname: f.nickname.to_s,
          openid: f.openid.to_s,
          upuser: upuser,
          agentlevel: agentlevel,
          created_at: f.created_at.strftime('%Y-%m-%d %H:%M:%S'),
          canwithdrawal: canwithdrawal
      }
      userarr.push user_param
    end
    param = {
        data: userarr,
        total: total,
        haswithdrawalcount: haswithdrawalcount,
        nowithdrawalcount: nowithdrawalcount
    }
    return_res(param)
  end

  def getupuser
    user = User.find(params[:id])
    userids = User.where('id not in (?)', excludeuser([user.id]))
    userarr = [{value:0,label:'无上级'},headurl:'']
    users = User.where(id:userids)
    users.each do |us|
      label = us.openid.to_s
      label = us.nickname if us.nickname.to_s.size > 0
      us_param = {
          value: us.id,
          label: label,
          headurl: us.headurl.to_s
      }
      userarr.push us_param
    end
    currentuser = {
        up_id: user.parent ? user.parent.id : 0,
        name: user.nickname.to_s.size > 0 ? user.nickname.to_s : user.openid.to_s,
        headurl: user.headurl.to_s
    }
    param = {
        options: userarr,
        currentuser: currentuser
    }
    return_res(param)
  end

  def setupuser
    data = JSON.parse(params[:data])
    user = User.find(data["id"])
    user.update(up_id: data["upid"])
    return_res('')
  end

  private

  def excludeuser(userids)
    users = User.where(id: userids)
    users.each do |f|
      userids += excludeuser(f.childrens.ids)
    end
    userids
  end
end

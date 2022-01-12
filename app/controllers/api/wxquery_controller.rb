class Api::WxqueryController < ApplicationController
  def shopmanager
    msg = ''
    user = User.find_by_token(params[:token])
    shop = Shop.find(params[:mid])
    shopusers = shop.shopusers
    manuser = shopusers.where(member: 0).first
    manager = shopusers.where(member: 1).first
    if manager && user.id == manager.user_id
      msg = "已经是#{shop.name}的管理员，无须重复扫码"
    elsif manager
      msg = "#{shop.name}已经存在管理员，如果需要变更为管理员，请联系管理员从我的店铺的用户中进行变更"
    elsif manuser && user.id == manuser.user_id
      manuser.update(member: 1)
      msg = "已从#{shop.name}的业务员变更为#{shop.name}的管理员"
    else
      if check_parent(user.id, user.id)
        msg = "你属于签约#{shop.name}业务员的上级，无法成为#{shop.name}的管理员"
      else
        shop.shopusers.create(user_id: user.id, member: 1)
        user.update(up_id: manuser.user_id)
        msg = "已成为#{shop.name}的管理员"
      end
    end
    return_api('',10000, msg)
  end

  def shopcustomer
    user = User.find_by_token(params[:token])
    shop = Shop.find(params[:sid])
    shopmanager = shop.shopusers.where(member: 1).first
    if user.up_id.to_i == 0 && shopmanager && !check_children(user.id, shopmanager.user_id)
      user.update(up_id: shopmanager.user_id)
    end
    return_api('')
  end

  def upuser
    user = User.find_by_token(params[:token])
    upuser = User.find(params[:uid])
    if user.up_id.to_i == 0 && !check_children(user.id, upuser.id) && user.created_at > Time.now - 1.days
      user.update(up_id: upuser.id)
      Backrun.oldpeople_invitationgift(upuser.id)
      Backrun.gift_luckdraw_times(upuser.id)
      parent = user.parent
      while parent do
        parent.update(peoplecount: parent.peoplecount.to_i + 1, mancount: parent.mancount.to_i + 1)
        data = {
            touser: parent.openid,
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
                    value: user.openid[-10,10],
                },
                keyword2: {
                    value: user.created_at.strftime('%Y-%m-%d %H:%M:%S'),
                },
                remark: {
                    value: "",
                }
            }
        }
        SendmpmsgJob.perform_later(parent.id, data.to_json)
        parent = parent.parent
      end
    end
    return_api('')
  end

  def liveupuser
    user = User.find_by_token(params[:token])
    if params[:res] && params[:share_openid]
    upuser = User.find_by_openid(params[:res][:share_openid])
    if upuser && user.up_id.to_i == 0 && user.id != upuser.id
      user.update(up_id: upuser.id)
      Backrun.oldpeople_invitationgift(upuser.id)
      parent = user.parent
      while parent do
        data = {
            touser: parent.openid,
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
                    value: user.openid[-10,10],
                },
                keyword2: {
                    value: user.created_at.strftime('%Y-%m-%d %H:%M:%S'),
                },
                remark: {
                    value: "",
                }
            }
        }
        SendmpmsgJob.perform_later(parent.id, data.to_json)
        parent = parent.parent
      end
    end
    end
    return_api('')
  end

  private

  def check_parent(userid, owerid)
    user = User.find(userid)
    parent = user.parent
    if parent && parent.id == owerid
      return true
      elsif parent
      check_parent(parent.id, owerid)
    end
    return false
  end

  def check_children(userid, owerid)
    user = User.find(userid)
    if user.id == owerid
      return true
    end
    childrens = user.childrens
    childrens.each do |f|
      check_children(f.id, owerid)
    end
    return false
  end
end

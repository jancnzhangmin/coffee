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
    if user.up_id.to_i == 0 && !check_children(user.id, upuser.id)
      user.update(up_id: upuser.id)
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

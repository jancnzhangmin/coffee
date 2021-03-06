class Api::TeamsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    users = user.childrens.order('id desc').page(params[:page]).per(10)
    final = 0
    final = 1 if users.last_page? || users.out_of_range?
    userarr = []
    users.each do |f|
      user_param = {
          id: f.id,
          headurl: f.headurl.to_s,
          nickname: f.nickname.to_s,
          salesum: get_year_salesum(f.id).to_s(:currency, unit:''),
          salecount: get_year_salecount(f.id),
          peoplecount: get_peoplecount(f.id),
          mancount: get_businecount(f.id, f.id, 'man'),
          directorcount: get_businecount(f.id, f.id, 'director'),
          managercount: get_businecount(f.id, f.id,'manager')
      }
      userarr.push user_param
    end
    team_param = {
        peoplecount: get_peoplecount(user.id),
        mancount: get_businecount(user.id, user.id, 'man'),
        directorcount: get_businecount(user.id, user.id, 'director'),
        managercount: get_businecount(user.id, user.id, 'manager')
    }
    param = {
        final: final,
        team: team_param,
        data: userarr
    }
    return_api(param)
  end

  private

  def get_year_salesum(userid, yearsum = 0)
    user = User.find(userid)
    yearsum = user.orders.where('paystatus = ? and created_at between ? and ?', 1, Time.now - 1.years, Time.now).sum('amount')
    childrens = user.childrens
    childrens.each do |f|
      yearsum += get_year_salesum(f.id, yearsum)
    end
    yearsum
  end

  def get_year_salecount(userid, yearcount = 0)
    user = User.find(userid)
    yearcount = user.orders.where('paystatus = ? and created_at between ? and ?', 1, Time.now - 1.years, Time.now).size
    childrens = user.childrens
    childrens.each do |f|
      yearcount += get_year_salecount(f.id, yearcount)
    end
    yearcount
  end

  def get_peoplecount(userid, pcount = 0)
    user = User.find(userid)
    childrens = user.childrens
    pcount = childrens.size
    childrens.each do |f|
      pcount += get_peoplecount(f.id, pcount)
    end
    pcount
  end

  def get_businecount(userid, selfid, businetype, pcount = 0)
    user = User.find(userid)
    agentlevel = Agentlevel.find_by_businetype(businetype)
    if user.examines.last.agentlevel_id == agentlevel.id && userid != selfid
      pcount = 1
    end
    childrens = user.childrens
    childrens.each do |f|
      pcount += get_businecount(f.id, selfid, businetype, pcount)
    end
    pcount
  end

end

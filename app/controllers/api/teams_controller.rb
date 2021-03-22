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
          salesum: get_year_salesum(f.id),
          salecount: get_year_salecount(f.id),
          peoplecount: get_peoplecount(f.id)
      }
      userarr.push user_param
    end
    team_param = {
        peoplecount: get_peoplecount(user.id),
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
end

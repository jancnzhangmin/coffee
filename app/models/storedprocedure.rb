class Storedprocedure
  def self.test
    get_year_salecount(26)
  end

  def self.test2
    get_year(26)
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

  def self.get_year(userid)
    userids = User.where("FIND_IN_SET(id,getChildrenOrg(#{userid}))").ids
    Order.where(user_id: userids).where('paystatus = ? and created_at between ? and ?', 1, Time.now - 1.years, Time.now).size
      #yearcount = User.where(id: userids).orders.where('paystatus = ? and created_at between ? and ?', 1, Time.now - 1.years, Time.now).size
  end
end
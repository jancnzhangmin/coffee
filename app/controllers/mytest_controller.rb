class MytestController < ApplicationController
  def index
    #Gencontract.testcontract
    #Gencontract.contractdraft(1,'sdf0d0sdf000',30,0,'玉溪红塔大酒店', '云南省玉溪市红塔区红塔大道156号')
    users = User.all
    userarr = []
    users.each do |user|
      levelcount = 0
      hasparent = true
      parent = user
      nicknames = [user.nickname.to_s]
      while levelcount < 100 && hasparent do
        parent = parent.parent
        if parent
          levelcount += 1
          nicknames.push parent.nickname.to_s
        else
          hasparent = false
        end
      end
      param = {
          nickname: user.nickname,
          levelcount: levelcount,
          nicknames: nicknames
      }
      userarr.push param
    end
    return_res(userarr)
  end

  def createuser
    #user = User.create(nickname: 'user' + rand(1000000).to_s, openid: 'openid' + rand(100000), up_id: 28)
    createchildren(26,10)
  end

  private
  def createchildren(userid, steptime)
    if steptime > 0
      2.times do
      user = User.create(nickname: 'user' + rand(1000000).to_s, openid: 'openid' + rand(100000).to_s, up_id: userid)
      createchildren(user.id, steptime - 1)
      end
    end
  end
end

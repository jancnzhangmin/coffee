class Api::PrizeController < ApplicationController
  def getprizelist
    luckdraw = Luckdraw.where('begintime <= ? and endtime >= ? and status = ?', Time.now, Time.now, 1).first
    prizelist = []
    if luckdraw
      luckdrawdetails = luckdraw.luckdrawdetails.order('corder')
      luckdrawdetails.each_with_index do |luckdrawdetail, index|
        product = Product.find_by(id: luckdrawdetail.product_id)
        prizeName = '谢谢参与'
        prizeImage = ''
        if product
          prizeName = product.name
          prizeImage = product.cover
        end
        luckdrawdetail_param = {
            prizeId: index + 1,
            prizeName: prizeName,
            prizeStock: 1,
            prizeWeight: 1,
            prizeImage: prizeImage
        }
        prizelist.push luckdrawdetail_param
      end
    end
    return_api(prizelist)
  end

  def setprizeindex #设置中奖下标
    luckdraw = Luckdraw.where('begintime <= ? and endtime >= ? and status = ?', Time.now, Time.now, 1).first
    prizeindex = -1
    if luckdraw
      leng = 0
      luckdrawdetails = luckdraw.luckdrawdetails.order('corder')
      luckdrawdetails.each do |luckdrawdetail|
        leng += luckdrawdetail.hitrate.to_f
      end
      luckdrawdetails.each_with_index do |luckdrawdetail, index|
        random = rand * leng
        if random <luckdrawdetail.hitrate.to_f
          prizeindex = index
          break
        else
          leng -=luckdrawdetail.hitrate.to_f
        end
      end
      user = User.find_by_token(params[:token])
      if luckdrawdetails[prizeindex].thank.to_i == 0
        user.giftdepots.create(
            product_id: luckdrawdetails[prizeindex].product_id,
            number: 1,
            expireday: 7,
            deletestatus: 0,
            usedstatus: 0,
            appointproduct_id: luckdrawdetails[prizeindex].appointproduct_id,
            summary: luckdraw.nametag
        )
        username = '**' + user.openid[-3,3]
        if user.nickname
          if user.nickname.size > 2
            username = '**' + user.nickname[-1,1]
          else
            username = '*' + user.nickname[-1,1]
          end
        end
        product = Product.find(luckdrawdetails[prizeindex].product_id)
        Luckdrawpublic.create(summary: username + ' 抽中' + product.name.to_s)
      end
      luckdrawtime = user.luckdrawtimes.where('begintime <= ? and endtime >= ?', Time.now, Time.now).first
      if luckdrawtime
        luckdrawtime.update(times: luckdrawtime.times - 1)
      end
    end
    param = {
        prizeindex: prizeindex
    }
    return_api(param)
  end

  def getprizepublic #获取中奖公告
    luckdrawpublics = Luckdrawpublic.order('created_at desc').limit(100)
    luckdrawpublicarr = []
    luckdrawpublics.each do |luckdrawpublic|
      prizetime = '刚刚'
      if Time.now > luckdrawpublic.created_at + 1.days
        prizetime = '1天前'
      elsif Time.now > luckdrawpublic.created_at + 1.hours
        prizetime = ((Time.now - luckdrawpublic.created_at) / 60 / 60).to_i.to_s + '小时前'
      elsif Time.now > luckdrawpublic.created_at + 2.minutes
        prizetime = ((Time.now - luckdrawpublic.created_at) / 60).to_i.to_s + '分钟前'
      end
      luckdrawpublic_param = {
          title: prizetime + ' ' + luckdrawpublic.summary,
          url: "",
          opentype: ""
      }
      luckdrawpublicarr.push luckdrawpublic_param
    end
    return_api(luckdrawpublicarr)
  end

  def getluckdrawtimes #获取抽奖次数
    freenum = 0
    user = User.find_by_token(params[:token])
    luckdrawtime = user.luckdrawtimes.where('begintime <= ? and endtime >= ?', Time.now, Time.now).first
    if luckdrawtime
      freenum = luckdrawtime.times.to_i
    end
    param = {
        freenum: freenum
    }
    return_api(param)
  end
end

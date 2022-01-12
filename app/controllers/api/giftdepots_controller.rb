class Api::GiftdepotsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    giftdepots = user.giftdepots.where('deletestatus <> ?', 1).order('id desc').page(params[:page]).per(10)
    final = 0
    final = 1 if giftdepots.last_page? || giftdepots.out_of_range?
    giftdepotarr = []
    giftdepots.each do |f|
      product = Product.find(f.product_id)
      expireday = (f.created_at + f.expireday.days - Time.now) / (24 * 3600)
      expirehour = (f.created_at + f.expireday.days - Time.now) / 3600
      expireminute = (f.created_at + f.expireday.days - Time.now) / 60
      expirestatus = 1
      if expireday > 1
        expiretime = expireday.to_i.to_s + '天后失效'
      elsif expirehour > 1
        expiretime = expirehour.to_i.to_s + '小时后失效'
      elsif
      expireminute > 1
        expiretime = expireminute.to_i.to_s + '分钟后失效'
      else
        expiretime = '已失效'
        expirestatus = 0
      end
      if f.usedstatus == 1
        expiretime = '已使用'
      end

      giftdepot_param = {
          id: f.id,
          name: product.name,
          cover: product.cover,
          product_id: f.product_id,
          number: f.number,
          expiretime: expiretime,
          expirestatus: expirestatus,
          usedstatus: f.usedstatus,
          created_at: f.created_at.strftime('%Y-%m-%d %H:%M:%S'),
          summary: f.summary
      }
      giftdepotarr.push giftdepot_param
    end
    param = {
        final: final,
        data: giftdepotarr
    }
    return_api(param)
  end
end

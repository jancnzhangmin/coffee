class Admin::ChangedomainsController < ApplicationController
  def create
    data = JSON.parse(params[:data])
    olddomain = data["olddomain"]
    newdomain = data["newdomain"]
    #'abc'.gsub(/a/, 'b') #返回'bbc'
    banners = Banner.all
    banners.each do |f|
      if f.banner.to_s.size > 0
        f.banner.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    imgresources = Imgresource.all
    imgresources.each do |f|
      if f.img.to_s.size > 0
        f.img.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    products = Product.all
    products.each do |f|
      if f.content.to_s.size > 0
        f.content.gsub!(/#{olddomain}/, newdomain)
      end
      if f.cover.to_s.size > 0
        f.cover.gsub!(/#{olddomain}/, newdomain)
      end
      f.save
    end
    contractdetails = Contractdetail.all
    contractdetails.each do |f|
      if f.contractimg.to_s.size > 0
        f.contractimg.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    posters = Poster.all
    posters.each do |f|
      if f.poster.to_s.size > 0
        f.poster.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
      if f.content.to_s.size > 0
        f.content.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    aftersaleimgs = Aftersaleimg.all
    aftersaleimgs.each do |f|
      if f.aftersaleimg.to_s.size > 0
        f.aftersaleimg.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    buyfullactives = Buyfullactive.all
    buyfullactives.each do |f|
      if f.cover.to_s.size > 0
        f.cover.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    buyparamvalues = Buyparamvalue.all
    buyparamvalues.each do |f|
      if f.cover.to_s.size > 0
        f.cover.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    contacttemplates = Contracttemplate.all
    contacttemplates.each do |f|
      if f.contracttemplate.to_s.size > 0
        f.contracttemplate.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    evaluateimgs = Evaluateimg.all
    evaluateimgs.each do |f|
      if f.evaluateimg.to_s.size > 0
        f.evaluateimg.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    invitationgifts = Invitationgift.all
    invitationgifts.each do |f|
      if f.cover.to_s.size > 0
        f.cover.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    productbanners = Productbanner.all
    productbanners.each do |f|
      if f.banner.to_s.size > 0
        f.banner.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    settings = Setting.all
    settings.each do |f|
      if f.qrcode.to_s.size > 0
        f.qrcode.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    shops = Shop.all
    shops.each do |f|
      if f.cover.to_s.size > 0
        f.cover.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    singlediscounts = Singlediscount.all
    singlediscounts.each do |f|
      if f.cover.to_s.size > 0
        f.cover.gsub!(/#{olddomain}/, newdomain)
        f.save
      end
    end
    return_res('')
  end
end

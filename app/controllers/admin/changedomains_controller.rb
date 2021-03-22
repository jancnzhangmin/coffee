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
    return_res('')
  end
end

class Admin::BannersController < ApplicationController
  def index
    banners = Banner.order('corder')
    total = banners.size
    banners = banners.page(params[:page]).per(params[:per])
    bannerarr = []
    banners.each do |f|
      banner_param = {
          id: f.id,
          banner: f.banner,
          link: f.link,
          corder: f.corder
      }
      bannerarr.push banner_param
    end
    param = {
        data: bannerarr,
        total: total
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    Banner.create(banner: data["banner"], link: data["link"])
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    banner = Banner.find(params[:id])
    banner.update(banner: data["banner"], link: data["link"])
    return_res('')
  end

  def show
    banner = Banner.find(params[:id])
    banner_param = {
        id: banner.id,
        banner: banner.banner,
        corder: banner.corder,
        value: banner.products.ids
    }
    return_res(banner_param)
  end

  def sort
    from_id = params[:from_id].to_i
    to_id = params[:to_id].to_i
    Banner.transaction do
      if from_id > to_id
        banners = Banner.where('corder <= ? and corder >= ?', from_id, to_id).order('corder asc')
      elsif to_id > from_id
        banners = Banner.where('corder >= ? and corder <= ?', from_id, to_id).order('corder desc')
      end
      banners.each_with_index do |item,index|
        nextitem = banners[index + 1]
        if nextitem
          item.update(corder: nextitem.corder)
        end
      end
      banners.last.update(corder: to_id)
    end
    return_res('')
  end

  def destroy
    banner = Banner.find(params[:id])
    banner.destroy
    return_res('')
  end
end

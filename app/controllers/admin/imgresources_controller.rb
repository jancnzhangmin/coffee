class Admin::ImgresourcesController < ApplicationController
  def index
    imgresources = Imgresource.order('created_at desc')
    total = imgresources.size
    imgresources = imgresources.page(params[:page]).per(params[:per])
    imgresourcearr = []
    imgresources.each do |f|
      imgresource_param = {
          id: f.id,
          img: f.img
      }
      imgresourcearr.push imgresource_param
    end
    param = {
        data: imgresourcearr,
        total: total
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    Imgresource.create(img: data["img"])
    return_res('')
  end

  def destroy
    imgresource = Imgresource.find(params[:id])
    imgresource.destroy
    return_res('')
  end
end

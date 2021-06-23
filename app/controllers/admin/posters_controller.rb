class Admin::PostersController < ApplicationController
  def index
    product = Product.find(params[:product_id])
    posters = product.posters.order('id desc')
    posterarr = []
    posters.each do |f|
      poster_param = {
          id: f.id,
          poster: f.poster,
          content: f.content,
      }
      posterarr.push poster_param
    end
    return_res(posterarr)
  end

  def create
    data = JSON.parse(params[:data])
    product = Product.find(params[:product_id])
    product.posters.create(poster: data["poster"])
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    poster = Poster.find(params[:id])
    poster.update(poster: data["poster"])
    return_res('')
  end

  def updatecontent
    poster = Poster.find(params[:id])
    poster.update(content:params[:content])
    return_res('')

  end

  def show
    poster = Poster.find(params[:id])
    qrcode = Setting.first.qrcode
    param = {
        data: poster,
        qrcode: qrcode
    }
    return_res(param)
  end

  def destroy
    poster = Poster.find(params[:id])
    poster.destroy
    return_res('')
  end
end
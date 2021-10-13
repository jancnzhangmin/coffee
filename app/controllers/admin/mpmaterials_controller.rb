class Admin::MpmaterialsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      mpmaterials = Mpmaterial.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      mpmaterials = Mpmaterial.all
    end
    total = mpmaterials.size
    mpmaterials = mpmaterials.page(params[:page]).per(params[:per])
    mpmaterialarr = []
    mpmaterials.each do |f|
      mpmaterial_param = {
          id: f.id,
          mediaid: f.mediaid,
          title: f.title,
          url: f.url
      }
      mpmaterialarr.push mpmaterial_param
    end
    param = {
        data: mpmaterialarr,
        total: total
    }
    return_res(param)
  end

  def create
    total_count = -1
    offset = 0
    while total_count == -1 || total_count > (offset + 1) * 20 do
      conn = Faraday.new(:url => 'https://api.weixin.qq.com/') do |faraday|
        faraday.request :url_encoded # form-encode POST params
        faraday.response :logger # log requests to STDOUT
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
      conn.params[:access_token] = Backrun.get_mpaccesstoken
      request = conn.post do |req|
        req.url 'cgi-bin/material/batchget_material'
        req.body = {
            type:'news',
            offset: offset,
            count: 20
        }.to_json
      end
      res = JSON.parse(request.body)
      if total_count == -1
        total_count = res["total_count"]
      end
      res["item"].each do |item|
        mpmaterial = Mpmaterial.find_by_mediaid(item["media_id"])
        if mpmaterial
          mpmaterial.update(mediaid: item["media_id"], title: item["content"]["news_item"][0]["title"], url: item["content"]["news_item"][0]["url"])
        else
          Mpmaterial.create(mediaid: item["media_id"], title: item["content"]["news_item"][0]["title"], url: item["content"]["news_item"][0]["url"])
        end
      end
      offset += 1
    end
    return_res('')
  end
end

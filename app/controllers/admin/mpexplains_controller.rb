class Admin::MpexplainsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      mpexplains = Mpexplain.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      mpexplains = Mpexplain.all.order('corder')
    end
    total = mpexplains.size
    mpexplains = mpexplains.page(params[:page]).per(params[:per])
    mpexplainarr = []
    mpexplains.each do |mpexplain|
      mpexplain_param = {
          id: mpexplain.id,
          title: mpexplain.title,
          url: mpexplain.url,
          corder: mpexplain.corder,
      }
      mpexplainarr.push mpexplain_param
    end
    param = {
        data: mpexplainarr,
        total: total
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    Mpexplain.create(title: data["title"], url: data["url"])
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    mpexplain = Mpexplain.find(params[:id])
    mpexplain.update(title: data["title"], url: data["url"])
    return_res('')
  end

  def destroy
    mpexplain = Mpexplain.find(params[:id])
    mpexplain.destroy
    return_res('')
  end

  def sort
    from_id = params[:from_id].to_i
    to_id = params[:to_id].to_i
    Mpexplain.transaction do
      if from_id > to_id
        mpexplains = Mpexplain.where('corder <= ? and corder >= ?', from_id, to_id).order('corder asc')
      elsif to_id > from_id
        mpexplains = Mpexplain.where('corder >= ? and corder <= ?', from_id, to_id).order('corder desc')
      end
      mpexplains.each_with_index do |item,index|
        nextproductcla = mpexplains[index + 1]
        if nextproductcla
          item.update(corder: nextproductcla.corder)
        end
      end
      mpexplains.last.update(corder: to_id)
    end
    return_res('')
  end
end

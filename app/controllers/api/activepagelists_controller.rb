class Api::ActivepagelistsController < ApplicationController
  def index
    activearr = []
    buyfullactives = Buyfullactive.where('begintime <= ? and endtime >= ? and status = ?', Time.now, Time.now, 1)
    buyfullactives.each do |buyfullactive|
      buyfullactive_param = {
          product_id: buyfullactive.product_id,
          img: buyfullactive.cover,
          endtime: buyfullactive.endtime.strftime('%Y-%m-%d %H:%M:%S'),
          name: buyfullactive.name,
          nametag: buyfullactive.nametag,
          summary: buyfullactive.summary,
          price: buyfullactive.price.to_s(:currency, unit: '')
      }
      activearr.push buyfullactive_param
    end

    singlediscounts = Singlediscount.where('begintime <= ? and endtime >= ? and status = ?', Time.now, Time.now, 1)
    singlediscounts.each do |singlediscount|
      singlediscount_param = {
          product_id: singlediscount.product_id,
          img: singlediscount.cover,
          endtime: singlediscount.endtime.strftime('%Y-%m-%d %H:%M:%S'),
          name: singlediscount.name,
          nametag: singlediscount.nametag,
          summary: singlediscount.summary,
          price: singlediscount.price.to_s(:currency, unit: '')
      }
      activearr.push singlediscount_param
    end
    return_api(activearr)
  end
end

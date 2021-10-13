class Api::ActivepagelistsController < ApplicationController
  def index
    buyfullactives = Buyfullactive.where('begintime <= ? and endtime >= ? and status = ?', Time.now, Time.now, 1)
    activearr = []
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
    return_api(activearr)
  end
end

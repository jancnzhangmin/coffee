class Api::AftersalesController < ApplicationController
  def index
    order = Order.find(params[:order_id])
    aftersales = order.aftersales
    aftersalearr = []
    aftersales.each do |f|
      aftersale_param = {
          id: f.id,
          contact: f.contact,
          summary: f.summary,
          reply: f.reply.to_s,
          imgs: f.aftersaleimgs.map(&:aftersaleimg),
          created_at: f.created_at.strftime('%Y-%m-%d %H:%M:%S')
      }
      aftersalearr.push aftersale_param
    end
    param = {
        afterstatus: order.afterstatus.to_i,
        aftersales: aftersalearr,
        contact: order.contactphone
    }
    return_api(param)
  end

  def create
    order = Order.find(params[:order_id])
    aftersale = order.aftersales.create(contact: params[:contact], summary: params[:summary])
    params[:imgs].each do |f|
      aftersale.aftersaleimgs.create(aftersaleimg: f)
    end
    order.update(afterstatus: 1)
    return_api('')
  end
end

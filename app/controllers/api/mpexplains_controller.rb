class Api::MpexplainsController < ApplicationController
  def index
    mpexplains = Mpexplain.all.order('corder')
    mpexplainarr = []
    mpexplains.each do |mpexplain|
      mpexplain_param = {
          id: mpexplain.id,
          title: mpexplain.title
      }
      mpexplainarr.push mpexplain_param
    end
    return_api(mpexplainarr)
  end

  def show
    mpexplain = Mpexplain.find(params[:id])
    mpexplain_param = {
        id: mpexplain.id,
        url: mpexplain.url
    }
    return_api(mpexplain_param)
  end
end

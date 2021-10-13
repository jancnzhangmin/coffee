class Admin::SettingsController < ApplicationController
  def index
    setting = Setting.first
    return_res(setting)
  end

  def update
    setting = Setting.find(params[:id])
    data = JSON.parse(params[:data])
    setting.update(appid: data["appid"],
                   appsecret: data["appsecret"],
                   mpappid: data["mpappid"],
                   mpappsecret: data["mpappsecret"],
                   firstprofit: data["firstprofit"],
                   secondprofit: data["secondprofit"],
                   kuaidikey: data["kuaidikey"],
                   qrcode: data["qrcode"],
                   autoreceive: data["autoreceive"],
                   autoevaluate: data["autoevaluate"]
                   )
    return_res('')
  end
end

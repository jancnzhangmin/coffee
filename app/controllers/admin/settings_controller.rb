class Admin::SettingsController < ApplicationController
  def index
    setting = Setting.first
    return_res(setting)
  end

  def update
    setting = Setting.find(params[:id])
    data = JSON.parse(params[:data])
    setting.update(appid: data["appid"], appsecret: data["appsecret"])
    return_res('')
  end
end

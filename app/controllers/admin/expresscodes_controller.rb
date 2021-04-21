class Admin::ExpresscodesController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      expresscodes = Expresscode.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      expresscodes = Expresscode.all
    end
    total = expresscodes.size
    expresscodes = expresscodes.page(params[:page]).per(params[:per])
    expresscodearr = []
    expresscodes.each do |f|
      expresscode_param = {
          id: f.id,
          name: f.name,
          comcode: f.comcode,
      }
      expresscodearr.push expresscode_param
    end
    param = {
        data: expresscodearr,
        total: total
    }
    return_res(param)
  end

  def create
    require 'roo'
    Expresscode.transaction do
      Expresscode.all.destroy_all
      xlsx = Roo::Spreadsheet.open(params[:file].tempfile)
      rowarr = (3..xlsx.sheet(0).last_row)
      sheet = xlsx.sheet(0)
      rowarr.each do |f|
        if sheet.row(f)[0].to_s.strip.size > 0 && sheet.row(f)[0].to_s.strip.size > 0
          Expresscode.create(name: sheet.row(f)[0].to_s.strip, comcode: sheet.row(f)[1].to_s.strip)
        end
      end
    end
    return_res('')
  end
end

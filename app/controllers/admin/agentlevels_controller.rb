class Admin::AgentlevelsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      agentlevels = Agentlevel.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      agentlevels = Agentlevel.all
    end
    agentlevels = agentlevels.order('corder asc')
    total = agentlevels.size
    agentlevels = agentlevels.page(params[:page]).per(params[:per])
    agentlevelarr = []
    agentlevels.each do |f|
      businetype = '业务员'
      if f.businetype == 'director'
        businetype = '业务主管'
      elsif f.businetype == 'manager'
        businetype = '业务经理'
      elsif f.businetype == 'partner'
        businetype = '合伙人'
      end
      agentlevel_param = {
          id: f.id,
          name: f.name,
          profitratio: f.profitratio,
          frontdisplay: f.frontdisplay.to_i,
          rebate: f.rebate,
          isyearend: f.isyearend.to_i,
          businetype: businetype,
          corder: f.corder.to_i
      }
      agentlevelarr.push agentlevel_param
    end
    param = {
        data: agentlevelarr,
        total: total
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    frontdisplay = 0
    frontdisplay = 1 if data["frontdisplay"]
    isyearend = 0
    isyearend = 1 if data["isyearend"]
    Agentlevel.create(
        name: data["name"],
        profitratio: data["profitratio"],
        frontdisplay: frontdisplay,
        isyearend: isyearend,
        rebate: data["rebate"],
        businetype: data["businetype"]
    )
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    frontdisplay = 0
    frontdisplay = 1 if data["frontdisplay"]
    agentlevel = Agentlevel.find(params[:id])
    isyearend = 0
    isyearend = 1 if data["isyearend"]
    agentlevel.update(
        name: data["name"],
        profitratio: data["profitratio"],
        frontdisplay: frontdisplay,
        isyearend: isyearend,
        rebate: data["rebate"],
        businetype: data["businetype"]
    )
    return_res('')
  end

  def show
    agentlevel = Agentlevel.find(params[:id])
    param = {
        id: agentlevel.id,
        name: agentlevel.name,
        profitratio: agentlevel.profitratio,
        frontdisplay: agentlevel.frontdisplay.to_i,
        isyearend: agentlevel.isyearend.to_i,
        rebate: agentlevel.rebate,
        businetype: agentlevel.businetype.to_s
    }
    return_res(param)
  end

  def destroy
    agentlevel = Agentlevel.find(params[:id])
    agentlevel.destroy
    return_res('')
  end

  def sort
    from_id = params[:from_id].to_i
    to_id = params[:to_id].to_i
    Agentlevel.transaction do
      if from_id > to_id
        agentlevels = Agentlevel.where('corder <= ? and corder >= ?', from_id, to_id).order('corder asc')
      elsif to_id > from_id
        agentlevels = Agentlevel.where('corder >= ? and corder <= ?', from_id, to_id).order('corder desc')
      end
      agentlevels.each_with_index do |item,index|
        nextagentlevel = agentlevels[index + 1]
        if nextagentlevel
          item.update(corder: nextagentlevel.corder)
        end
      end
      agentlevels.last.update(corder: to_id)
    end
    return_res('')
  end
end

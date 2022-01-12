class Admin::InvitationgiftsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      invitationgifts = Invitationgift.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      invitationgifts = Invitationgift.all.order('id desc')
    end
    total = invitationgifts.size
    invitationgifts = invitationgifts.page(params[:page]).per(params[:per])
    inviationgifttarr = []
    invitationgifts.each do |inviationgift|
      inviationgift_param = {
          id: inviationgift.id,
          name: inviationgift.name,
          nametag: inviationgift.nametag,
          begintimestr: inviationgift.begintime.strftime('%Y-%m-%d %H:%M:%S'),
          endtimestr: inviationgift.endtime.strftime('%Y-%m-%d %H:%M:%S'),
          begintime: inviationgift.begintime,
          endtime: inviationgift.endtime,
          status: inviationgift.status,
          cover: inviationgift.cover,
          summary: inviationgift.summary,
          product_id: inviationgift.product_id,
          product: Product.find(inviationgift.product_id).name,
          appointproduct_id: inviationgift.appointproduct_id,
          appointproduct: Appointproduct.find(inviationgift.appointproduct_id),
          newpeople: inviationgift.newpeople,
          oldpeople: inviationgift.oldpeople,
          expireday: inviationgift.expireday
      }
      inviationgifttarr.push inviationgift_param
    end
    param = {
        data: inviationgifttarr,
        total: total
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    status = 0
    status = 1 if data["state"]
    newpeople = 0
    newpeople = 1 if data["newpeople"]
    oldpeople = 0
    oldpeople = 1 if data["oldpeople"]
    Invitationgift.create(
        name: data["name"],
        nametag: data["nametag"],
        begintime: data["daterange"][0],
        endtime: data["daterange"][1],
        product_id: data["product_id"],
        appointproduct_id: data["appointproduct_id"],
        cover: data["cover"],
        newpeople: newpeople,
        oldpeople: oldpeople,
        status: status,
        summary: data["summary"],
        expireday: data["expireday"]
    )
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    status = 0
    status = 1 if data["state"]
    newpeople = 0
    newpeople = 1 if data["newpeople"]
    oldpeople = 0
    oldpeople = 1 if data["oldpeople"]
    invitationgift = Invitationgift.find(params[:id])
    invitationgift.update(
        name: data["name"],
        nametag: data["nametag"],
        begintime: data["daterange"][0],
        endtime: data["daterange"][1],
        product_id: data["product_id"],
        appointproduct_id: data["appointproduct_id"],
        cover: data["cover"],
        newpeople: newpeople,
        oldpeople: oldpeople,
        status: status,
        summary: data["summary"],
        expireday: data["expireday"]
    )
    return_res('')
  end

  def show
    invitationgift = Invitationgift.find(params[:id])
    param = {
        id: invitationgift.id,
        name: invitationgift.name,
        nametag: invitationgift.nametag,
        begintime: invitationgift.begintime,
        endtime: invitationgift.endtime,
        product_id: invitationgift.product_id,
        appointproduct_id: invitationgift.appointproduct_id,
        cover: invitationgift.cover,
        newpeople: invitationgift.newpeople,
        oldpeople: invitationgift.oldpeople,
        status: invitationgift.status,
        summary: invitationgift.summary,
        expireday: invitationgift.expireday
    }
    return_res(param)
  end

  def destroy
    invitationgift = Invitationgift.find(params[:id])
    invitationgift.destroy
    return_res('')
  end

  def get_appointproducts
    appointproducts = Appointproduct.all
    appointproductarr = []
    appointproducts.each do |f|
      appointproduct_param = {
          value: f.id,
          label: f.name
      }
      appointproductarr.push appointproduct_param
    end
    return_res(appointproductarr)
  end
end

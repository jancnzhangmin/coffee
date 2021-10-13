class Admin::WithdrawalsController < ApplicationController
  def index
    user = User.find(params[:user_id])
    withdrawals = user.withdrawals.where(status: 1)
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      withdrawals = withdrawals.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      withdrawals = withdrawals.order('id desc')
    end
    total = withdrawals.size
    hasamountcount = withdrawals.where(status: 1).sum('amount').to_s(:currency, unit: '')
    noamountcount = user.incomes.where(status: 1).sum('amount') - withdrawals.where(status: 1).sum('amount')
    noamountcount = noamountcount.to_s(:currency, unit: '')
    withdrawals = withdrawals.page(params[:page]).per(params[:per])
    withdrawalarr = []
    withdrawals.each do |f|
      withdrawal_param = {
          id: f.id,
          ordernumber: f.ordernumber,
          amount: f.amount.to_s(:currency, unit: ''),
          created_at: f.created_at.strftime('%Y-%m-%d %H:%M:%S'),
      }
      withdrawalarr.push withdrawal_param
    end

    param = {
        data: withdrawalarr,
        total: total,
        hasamountcount: hasamountcount,
        noamountcount: noamountcount
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    user = User.find(data["user_id"])
    ordernumber = UUIDTools::UUID.timestamp_create.to_s.tr('-','').to_i(16).to_s[0,20]
    user.withdrawals.create(ordernumber: ordernumber, amount: data["amount"], status: 1)
    return_res('')
  end
end

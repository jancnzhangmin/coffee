class Admin::WithdrawalrecordsController < ApplicationController
  def index
    withdrawals = Withdrawal.where(status: 1)
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      withdrawals = withdrawals.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      withdrawals = withdrawals.order('id desc')
    end
    total = withdrawals.size
    hasamountcount = withdrawals.where(status: 1).sum('amount').to_s(:currency, unit: '')
    noamountcount = Income.where(status: 1).sum('amount') - withdrawals.where(status: 1).sum('amount')
    noamountcount = noamountcount.to_s(:currency, unit: '')
    withdrawals = withdrawals.page(params[:page]).per(params[:per])
    withdrawalarr = []
    withdrawals.each do |f|
      user = f.user
      name = user.openid
      name = user.nickname if user.nickname.to_s.size > 0
      withdrawal_param = {
          id: f.id,
          headurl: user.headurl,
          name: name,
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
end

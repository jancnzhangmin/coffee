class Api::WithdrawalsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    withdrawals = user.withdrawals.where(status: 1).order('id desc').page(params[:page]).per(20)
    final = 0
    final = 1 if withdrawals.last_page? || withdrawals.out_of_range?
    withdrawalarr = []
    withdrawals.each do |f|
      withdrawal_param = {
          id: f.id,
          amount: f.amount.to_s(:currency, unit: ''),
          ordernumber: f.ordernumber,
          created_at: f.created_at.strftime('%Y-%m-%d %H:%M:%S'),
      }
      withdrawalarr.push withdrawal_param
    end
    param = {
        final: final,
        data: withdrawalarr
    }
    return_api(param)
  end

  def create
    status = 10000
    msg = '佣金已到账，请留意微信零钱变化'
    user = User.find_by_token(params[:token])
    canwithdrawal = (user.incomes.where(status: 1).sum('amount') - user.withdrawals.where(status: 1).sum('amount')).round(2)
    if canwithdrawal >= params[:amount].to_f
    ordernumber = UUIDTools::UUID.timestamp_create.to_s.tr('-','').to_i(16).to_s[0,20]
    withdrawal = user.withdrawals.create(ordernumber: ordernumber, amount: params[:amount], status: 0)
    nonce=SecureRandom.uuid.tr('-', '')
    payment_params = {
        nonce_str:nonce,
        partner_trade_no: withdrawal.ordernumber,
        openid: user.openid,
        check_name:'NO_CHECK',
        amount: (withdrawal.amount * 100).to_i,
        desc:'米三小粒咖啡佣金',
        spbill_create_ip:'127.0.0.1'
    }
    result = WxPay::Service.invoke_transfer(payment_params)
    if result["result_code"] == "SUCCESS"
      withdrawal.update(status: 1)
    else
      status = 10001
      msg = result["err_code_des"]
    end
    else
      status = 10001
      msg = '可提现余额不足'
    end
    return_api('', status, msg)
  end
end

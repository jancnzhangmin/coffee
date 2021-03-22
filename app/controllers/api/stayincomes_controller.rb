class Api::StayincomesController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    incomes = user.incomes.where('status =  ?', 0).order('id desc').page(params[:page]).per(10)
    final = 0
    final = 1 if incomes.last_page? || incomes.out_of_range?
    incomesarr = []
    incomes.each do |f|
      profittype = '分销收入'
      if f.profittype == 'rebate'
        profittype = '同级返点'
      elsif f.profittype == 'team'
        profittype = '团队收入'
      end
      income_param = {
          id: f.id,
          amount: ActiveSupport::NumberHelper.number_to_currency(f.amount, unit:''),
          ordernumber: f.ordernumber,
          summary: f.summary.to_s,
          profittype: profittype,
          created_at: f.created_at.strftime('%Y-%m-%d %H:%M:%S'),
      }
      incomesarr.push income_param
    end
    param = {
        final: final,
        data: incomesarr
    }
    return_api(param)
  end
end

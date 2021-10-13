class Api::FinancesController < ApplicationController
  def get_financeing
    if params[:cycle] == 'week'
      begintime = Time.now - 6.days
    elsif params[:cycle] == 'month'
      begintime = Time.now - 1.month
    elsif params[:cycle] == 'quarter'
      begintime = Time.now - 3.month
    elsif params[:cycle] == 'year'
      begintime = Time.now - 1.years
    end
    begintime = begintime.beginning_of_day
    endtime = Time.now.end_of_day
    user = User.find_by_token(params[:token])
    #ordercount = Backrun.cal_cycle_order_size(user.id, begintime, endtime)
    ordercount = Order.where('paytime between ? and ? and id in (?)', begintime, endtime, user.teamorderids + [0]).size
    stayincome = user.incomes.where('status = ? and created_at between ? and ?', 0, begintime, endtime).sum('amount').round(2)
    income = user.incomes.where('status = ? and created_at between ? and ?', 1, begintime, endtime).sum('amount').round(2)
    canwithdrawal = (income - user.withdrawals.where(status: 0).sum('amount')).round(2)
    withdrawal = user.withdrawals.where(status: 1).sum('amount').round(2)
    param = {
        ordercount: ordercount.to_f,
        stayincome: stayincome.to_f,
        income: income.to_f,
        canwithdrawal: canwithdrawal.to_f,
        withdrawal: withdrawal.to_f
    }
    return_api(param)
  end

  def get_financearea
    if params[:cycle] == 'week'
      begintime = Time.now - 6.days
    elsif params[:cycle] == 'month'
      begintime = Time.now - 1.month
    elsif params[:cycle] == 'quarter'
      begintime = Time.now - 3.month
    elsif params[:cycle] == 'year'
      begintime = Time.now - 1.years
    end
    begintime = begintime.beginning_of_day
    endtime = Time.now.end_of_day
    user = User.find_by_token(params[:token])
    categories = []
    saledata = []
    incomedata = []
    if params[:cycle] == 'week' || params[:cycle] == 'month' || params[:cycle] == 'quarter'
      while begintime <= endtime
        small_begintime = begintime
        small_endtime = begintime.end_of_day
        categories.push begintime.strftime('%m').to_i.to_s + '-' + begintime.strftime('%d').to_i.to_s
        #saledata.push Backrun.cal_cycle_sale(user.id, small_begintime, small_endtime).round(2)
        saledata.push Order.where('paytime between ? and ? and id in (?)', small_begintime, small_endtime, user.teamorderids + [0]).sum('amount').round(2)
        incomedata.push user.incomes.where('status = ? and created_at between ? and ?', 1, small_begintime, small_endtime).sum('amount').round(2)
        begintime = begintime + 1.days
      end
    elsif params[:cycle] == 'year'
      while begintime <= endtime
        small_begintime = begintime
        small_endtime = begintime.end_of_month
        categories.push begintime.strftime('%m').to_i.to_s + '月'
        #saledata.push Backrun.cal_cycle_sale(user.id, small_begintime, small_endtime).round(2)
        saledata.push Order.where('paytime between ? and ? and id in (?)', small_begintime, small_endtime, user.teamorderids + [0]).sum('amount').round(2)
        incomedata.push user.incomes.where('status = ? and created_at between ? and ?', 1, small_begintime, small_endtime).sum('amount').round(2)
        begintime = begintime + 1.month
      end
    end
    param = {
        saledata: saledata,
        incomedata: incomedata,
        categories: categories
    }
    return_api(param)
  end

  def get_financelist
    if params[:cycle] == 'week'
      begintime = Time.now - 6.days
    elsif params[:cycle] == 'month'
      begintime = Time.now - 1.month
    elsif params[:cycle] == 'quarter'
      begintime = Time.now - 3.month
    elsif params[:cycle] == 'year'
      begintime = Time.now - 1.years
    end
    begintime = begintime.beginning_of_day
    endtime = Time.now.end_of_day
    user = User.find_by_token(params[:token])
    #sales = Backrun.cal_cycle_sale(user.id, begintime, endtime).to_s(:currency, unit:'')
    sales = Order.where('paytime between ? and ? and id in (?)', begintime, endtime, user.teamorderids + [0]).sum('amount').to_s(:currency, unit: '')
    incomes = user.incomes.where('status = ? and created_at between ? and ?', 1,begintime, endtime).sum('amount').to_s(:currency, unit:'')
    #ordercount = Backrun.cal_cycle_order_size(user.id, begintime, endtime)
    ordercount = Order.where('paytime between ? and ? and id in (?)', begintime, endtime, user.teamorderids + [0]).size
    incomecount = user.incomes.where('status = ? and created_at between ? and ?', 1, begintime, endtime).size
    begintime = begintime.strftime('%Y-%m-%d')
    endtime = endtime.strftime('%Y-%m-%d')
    param = {
        sales: sales,
        incomes: incomes,
        ordercount: ordercount,
        incomecount: incomecount,
        begintime: begintime,
        endtime: endtime
    }
    return_api(param)
  end
end

class Admin::PublicmethodsController < ApplicationController
  def get_today
    param = {
        timestart: Time.now.strftime('%Y-%m-%d'),
        timeend: Time.now.strftime('%Y-%m-%d')
    }
    return_res(param)
  end

  def get_yesterday
    param = {
        timestart: (Time.now - 1.days).strftime('%Y-%m-%d'),
        timeend: (Time.now - 1.days).strftime('%Y-%m-%d')
    }
    return_res(param)
  end

  def get_week
    param = {
        timestart: Time.now.beginning_of_week.strftime('%Y-%m-%d'),
        timeend: Time.now.strftime('%Y-%m-%d')
    }
    return_res(param)
  end

  def get_month
    param = {
        timestart: Time.now.beginning_of_month.strftime('%Y-%m-%d'),
        timeend: Time.now.strftime('%Y-%m-%d')
    }
    return_res(param)
  end

  def get_quarter
    param = {
        timestart: Time.now.beginning_of_quarter.strftime('%Y-%m-%d'),
        timeend: Time.now.strftime('%Y-%m-%d')
    }
    return_res(param)
  end

  def get_year
    param = {
        timestart: Time.now.beginning_of_year.strftime('%Y-%m-%d'),
        timeend: Time.now.strftime('%Y-%m-%d')
    }
    return_res(param)
  end

  def get_lastyear
    param = {
        timestart: (Time.now - 1.years).beginning_of_year.strftime('%Y-%m-%d'),
        timeend: (Time.now - 1.years).end_of_year.strftime('%Y-%m-%d')
    }
    return_res(param)
  end

  def get_nearday
    param = {
        timestart: (Time.now - 2.days).strftime('%Y-%m-%d'),
        timeend: Time.now.strftime('%Y-%m-%d')
    }
    return_res(param)
  end

  def get_nearweek
    param = {
        timestart: (Time.now - 6.days).strftime('%Y-%m-%d'),
        timeend: Time.now.strftime('%Y-%m-%d')
    }
    return_res(param)
  end

  def get_nearmonth
    param = {
        timestart: (Time.now - 2.month).strftime('%Y-%m-%d'),
        timeend: Time.now.strftime('%Y-%m-%d')
    }
    return_res(param)
  end
end

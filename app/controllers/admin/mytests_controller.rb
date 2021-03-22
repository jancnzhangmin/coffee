class Admin::MytestsController < ApplicationController
  def index
    digui(10850)
    return_res('')
  end

  private
  def digui(levelcount)
    levelcount -= 1
    if levelcount > 0
      digui(levelcount)
    end
  end
end

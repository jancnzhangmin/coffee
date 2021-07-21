class ApplicationController < ActionController::API
  def return_res(result, status = 10000, msg = 'OK')
    param = {
        status: status,
        msg: msg,
        result: result
    }
    render json: param.to_json,content_type: "application/javascript"
  end

  def return_api(result, status = 10000, msg = 'OK')
    if result.class == String
      sign = Digest::SHA1.hexdigest(result)
    else
      sign = Digest::SHA1.hexdigest(result.map{|n|n}.join(','))
    end
    param = {
        status: status,
        msg: msg,
        sign: sign,
        result: result
    }
    render json: param.to_json,content_type: "application/javascript"
  end

end

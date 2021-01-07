class Admin::ResourcesController < ApplicationController
  def create
    data = []
    params.keys.each do |f|
      if params[f].class == ActionDispatch::Http::UploadedFile
        resource = Resource.new(resource: params[f])
        resource.save
        data.push Rails.configuration.serverurl + resource.resource.url
      end
    end
    param = {
        status:'ok',
        errno: 0,
        data: data
    }
    render json: param.to_json,content_type: "application/javascript"
  end
end

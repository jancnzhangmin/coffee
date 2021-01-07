class Admin::ProductbannersController < ApplicationController
  def index
    product = Product.find(params[:product_id])
    productbanners = product.productbanners
    productbannerarr = []
    productbanners.each do |f|
      productbanner_param = {
          id: f.id,
          imgurl: f.banner
      }
      productbannerarr.push productbanner_param
    end
    return_res(productbannerarr)
  end

  def create
    product = Product.find(params[:product_id])
    resource = Resource.create(resource: params[:file])
    product.productbanners.create(banner: Rails.configuration.serverurl + resource.resource.url)
    productbanners = product.productbanners.order('corder')
    productbannerarr = []
    productbanners.each do |f|
    productbanner_param = {
        id: f.id,
        imgurl: f.banner
    }
    productbannerarr.push productbanner_param
    end
    return_res(productbannerarr)
  end

  def destroy
    productbanner = Productbanner.find(params[:id])
    productbanner.destroy
    return_res('')
  end
end

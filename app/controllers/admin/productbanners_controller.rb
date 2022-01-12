class Admin::ProductbannersController < ApplicationController
  def index
    product = Product.find(params[:product_id])
    productbanners = product.productbanners.order(:corder)
    productbannerarr = []
    productbanners.each do |f|
      productbanner_param = {
          id: f.id,
          imgurl: f.banner,
          corder: f.corder
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

  def sort
    from_id = params[:from_id].to_i
    to_id = params[:to_id].to_i
    product = Product.find(params[:product_id])
    Productbanner.transaction do
      if from_id > to_id
        productbanners = product.productbanners.where('corder <= ? and corder >= ?', from_id, to_id).order('corder asc')
      elsif to_id > from_id
        productbanners = product.productbanners.where('corder >= ? and corder <= ?', from_id, to_id).order('corder desc')
      end
      productbanners.each_with_index do |item,index|
        nextproductcla = productbanners[index + 1]
        if nextproductcla
          item.update(corder: nextproductcla.corder)
        end
      end
      productbanners.last.update(corder: to_id)
    end
    return_res('')
  end
end

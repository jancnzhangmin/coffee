class Admin::ProductexplainsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      productexplains = Productexplain.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      productexplains = Productexplain.all
    end
    total = productexplains.size
    productexplains = productexplains.page(params[:page]).per(params[:per])
    productexplainarr = []
    productexplains.each do |f|
      productexplain_param = {
          id: f.id,
          title: f.title,
          number: f.products.size,
          ispublic: f.ispublic.to_i
      }
      productexplainarr.push productexplain_param
    end
    param = {
        data: productexplainarr,
        total: total
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    ispublic = 0
    ispublic = 1 if data["ispublic"]
    productexplain = Productexplain.create(title: data["title"], content: data["content"], ispublic: ispublic)
    data["value"].each do |f|
      product = Product.find(f)
      productexplain.products << product
    end
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    ispublic = 0
    ispublic = 1 if data["ispublic"]
    productexplain = Productexplain.find(params[:id])
    productexplain.update(title: data["title"], content: data["content"], ispublic: ispublic)
    productexplain.products.destroy_all
    data["value"].each do |f|
      product = Product.find(f)
      productexplain.products << product
    end
    return_res('')
  end

  def show
    productexplain = Productexplain.find(params[:id])
    param = {
        id: productexplain.id,
        title: productexplain.title,
        content: productexplain.content,
        value: productexplain.products.ids,
        ispublic: productexplain.ispublic.to_i
    }
    return_res(param)
  end

  def destroy
    productexplain = Productexplain.find(params[:id])
    productexplain.destroy
    return_res('')
  end
end

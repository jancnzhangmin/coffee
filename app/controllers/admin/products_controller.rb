class Admin::ProductsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      products = Product.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      products = Product.all
    end
    total = products.size
    products = products.page(params[:page]).per(params[:per])
    productarr = []
    products.each do |product|
      product_param = {
          id:product.id,
          name:product.name,
          subname:product.subname,
          cost: ActiveSupport::NumberHelper.number_to_currency(product.cost, unit:''),
          price:ActiveSupport::NumberHelper.number_to_currency(product.price, unit:''),
          proprice:ActiveSupport::NumberHelper.number_to_currency(product.proprice, unit:''),
          onsale: product.onsale.to_i,
          content: product.content,
          salecount: product.salecount.to_i,
          cover: product.cover,
          bannercount: product.productbanners.size,
          showparamcount: product.showparams.size,
          postercount: product.posters.size
      }
      productarr.push product_param
    end
    param = {
        data: productarr,
        total: total
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    onsale = 0
    onsale = 1 if data["onsale"]
    Product.create(
        name: data["name"],
        subname: data["subname"],
        cost: data["cost"],
        price: data["price"],
        proprice: data["proprice"],
        onsale: onsale,
        content: data["content"],
        cover: data["cover"]
    )
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    onsale = 0
    onsale = 1 if data["onsale"]
    product = Product.find(params[:id])
    product.update(
        name: data["name"],
        subname: data["subname"],
        cost: data["cost"],
        price: data["price"],
        proprice: data["proprice"],
        onsale: onsale,
        content: data["content"],
        cover: data["cover"]
    )
    return_res('')
  end

  def show
    product = Product.find(params[:id])
    if product
      return_res(product)
    else
      return_res('', 10001, '无效的记录值')
    end
  end
end

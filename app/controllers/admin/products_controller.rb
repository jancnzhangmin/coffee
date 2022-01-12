class Admin::ProductsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      products = Product.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      products = Product.all
    end
    if params[:producttype] == "sale"
      products = products.where(onsale: 1)
    elsif params[:producttype] == "down"
      products = products.where(onsale: 0)
    end
    products = products.where('name like ?', "%#{params[:filtervalue]}%")
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
          postercount: product.posters.size,
          startnumber: product.startnumber.to_i,
          retailstartnumber: product.retailstartnumber.to_i,
          buyparamcount: product.buyparams.size,
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
        supplier_id: data["supplier_id"],
        name: data["name"],
        subname: data["subname"],
        cost: data["cost"],
        price: data["price"],
        proprice: data["proprice"],
        onsale: onsale,
        content: data["content"],
        cover: data["cover"],
        startnumber: data["startnumber"],
        retailstartnumber: data["retailstartnumber"],
        suppliername: data["suppliername"]
    )
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    onsale = 0
    onsale = 1 if data["onsale"]
    product = Product.find(params[:id])
    product.update(
        supplier_id: data["supplier_id"],
        name: data["name"],
        subname: data["subname"],
        cost: data["cost"],
        price: data["price"],
        proprice: data["proprice"],
        onsale: onsale,
        content: data["content"],
        cover: data["cover"],
        startnumber: data["startnumber"],
        retailstartnumber: data["retailstartnumber"],
        suppliername: data["suppliername"]
    )
    return_res('')
  end

  def show
    product = Product.find(params[:id])
    suppliers = Supplier.all
    supplierarr = []
    suppliers.each do |supplier|
      supplier_param = {
          value: supplier.id,
          label: supplier.name
      }
      supplierarr.push supplier_param
    end
    product_param = {
        id: product.id,
        supplier_id: product.supplier_id,
        suppliers: supplierarr,
        name: product.name,
        suppliername: product.suppliername,
        subname: product.subname,
        cost: product.cost,
        price: product.price,
        proprice: product.proprice,
        onsale: product.onsale.to_i,
        content: product.content,
        cover: product.cover,
        startnumber: product.startnumber,
        retailstartnumber: product.retailstartnumber
    }
    return_res(product_param)
  end
end

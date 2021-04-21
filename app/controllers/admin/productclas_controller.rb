class Admin::ProductclasController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      productclas = Productcla.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      productclas = Productcla.all
    end
    productclas = productclas.order('corder')
    total = productclas.size
    productclas = productclas.page(params[:page]).per(params[:per])
    productclaarr = []
    productclas.each do |productcla|
      productcla_param = {
          id: productcla.id,
          name: productcla.name,
          ispro: productcla.ispro.to_i,
          number: productcla.products.size,
          corder: productcla.corder,
          keyword: productcla.keyword
      }
      productclaarr.push productcla_param
    end
    param = {
        data: productclaarr,
        total: total
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    ispro = 0
    ispro = 1 if data["ispro"]
    productcla = Productcla.create(
        name: data["name"],
        ispro: ispro,
        keyword: data["keyword"]
    )
    data["value"].each do |f|
      product = Product.find(f)
      productcla.products << product
    end
    return_res('')
  end

  def update
    data = data = JSON.parse(params[:data])
    ispro = 0
    ispro = 1 if data["ispro"]
    productcla = Productcla.find(params[:id])
    productcla.update(
        name: data["name"],
        ispro: ispro,
        keyword: data["keyword"]
    )
    productcla.products.destroy_all
    data["value"].each do |f|
      product = Product.find(f)
      productcla.products << product
    end
    return_res('')
  end

  def show
    productcla = Productcla.find(params[:id])
    param = {
        id: productcla.id,
        name: productcla.name,
        ispro: productcla.ispro.to_i,
        value: productcla.products.ids,
        keyword: productcla.keyword.to_s
    }
    return_res(param)
  end

  def destroy
    productcla = Productcla.find(params[:id])
    productcla.destroy
    return_res('')
  end

  def getproducts
    products = Product.all
    productarr = []
    products.each do |f|
      product_param = {
          key: f.id,
          label: f.name
      }
      productarr.push product_param
    end
    return_res(productarr)
  end

  def sort
    from_id = params[:from_id].to_i
    to_id = params[:to_id].to_i
    Productcla.transaction do
      if from_id > to_id
        productclas = Productcla.where('corder <= ? and corder >= ?', from_id, to_id).order('corder asc')
      elsif to_id > from_id
        productclas = Productcla.where('corder >= ? and corder <= ?', from_id, to_id).order('corder desc')
      end
      productclas.each_with_index do |item,index|
        nextproductcla = productclas[index + 1]
        if nextproductcla
          item.update(corder: nextproductcla.corder)
        end
      end
      productclas.last.update(corder: to_id)
    end
    return_res('')
  end

  def checkkeyword
    status = true
    productcla = Productcla.find_by_keyword(params[:keyword])
    if params[:keyword].to_s.size != 0 && productcla
      status = false
    end
    return_res(status)
  end

end

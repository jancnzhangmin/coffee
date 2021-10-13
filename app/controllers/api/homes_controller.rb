class Api::HomesController < ApplicationController
  def getswiper
    banners = Banner.all.order('corder')
    bannerarr = []
    banners.each do |f|
      banner_param = {
          img: f.banner,
          url: '',
          title: '',
          opentype: 'navigate'
      }
      bannerarr.push banner_param
    end
    param = {
        banners: bannerarr
    }
    return_api(param)
  end

  def getproductlist
    user = User.find_by_token(params[:token])
    products = Product.where('onsale = ?', 1)
    productarr = []
    products.each do |f|
      price = f.price
      shopusers = user.shopusers.where('member <> ?', 0)
      price = f.proprice.to_f if shopusers.size > 0 && f.proprice.to_f > 0
      product_param = {
          id: f.id,
          name: f.name,
          subname: f.subname,
          price: price,
          img: f.cover.to_s,
          priceMarket: f.price
      }
      productarr.push product_param
    end
    param = {
        products: productarr
    }
    return_api(param)
  end

  def gethotsales
    user = User.find_by_token(params[:token])
    # hotsales = Hotsale.all.order('corder')
    # productarr = []
    # hotsales.each do |f|
    #   product = f.product
    #   if product && product.onsale == 1
    #     price = product.price
    #     shopusers = user.shopusers.where('member <> ?', 0)
    #     price = product.proprice.to_f if shopusers.size > 0 && product.proprice.to_f > 0
    #     product_param = {
    #         id: product.id,
    #         name: product.name,
    #         subname: product.subname,
    #         price: price,
    #         img: product.cover.to_s,
    #         priceMarket: product.price
    #     }
    #     productarr.push product_param
    #   end
    # end
    # param = {
    #     products: productarr
    # }

    ids = JSON.parse(params[:ids])
    products = Product.where('onsale = ? and id not in (?)', 1, ids + [0]).first(10)
    orderarr = (0..products.size - 1).to_a
    orderarr.shuffle!
    productarr = []
    shopusers = user.shopusers.where('member <> ?', 0)
    orderarr.size.times do |i|
      price = products[orderarr[i]].price
      price = products[orderarr[i]].proprice.to_f if shopusers.size > 0 && products[orderarr[i]].proprice.to_f > 0
      buyfullactives = Buyfullactive.where('begintime <= ? and endtime >= ? and status = ? and product_id = ?', Time.now, Time.now, 1, products[orderarr[i]].id)
      activetag = buyfullactives.map(&:nametag)
      product_param = {
          id: products[orderarr[i]].id,
          name: products[orderarr[i]].name,
          subname: products[orderarr[i]].subname,
          price: price,
          img: products[orderarr[i]].cover.to_s,
          priceMarket: products[orderarr[i]].price,
          proprice: products[orderarr[i]].proprice.to_f,
          activetag: activetag
      }
      productarr.push product_param
    end
    final = 0
    final = 1 if products.size == 0

    param = {
        products: productarr,
        final: final
    }
    return_api(param)





  end

  def get_live_status
    livestatus = 0
    roomid = 0
    live = Live.first
    #user = User.find_by_token(params[:token])
    if live && live.status == 1
      livestatus = 1
      roomid = live.roomid
    end
    param = {
        livestatus: livestatus,
        roomid: roomid
    }
    return_api(param)
  end
end

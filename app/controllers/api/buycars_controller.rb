class Api::BuycarsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    buycars = getbuycars(user.id,params[:shoudan].to_i, params[:chooseproprice].to_i, params[:shopid].to_i)
    return_api(buycars)
  end

  def create
    user = User.find_by_token(params[:token])
    buycars = user.buycars
    product_id = params[:datas][2][0].to_i
    number = params[:datas][0].to_i
    product = Product.find(product_id)

#修正一品多规格
    buyparams = []
    params[:datas][2].each do |f|
      if f.class == Array
        buyparams.push f
      end
    end
    productbuycars = buycars.where(product_id: product_id)
    if number <= 0
      productbuycars.each do |productbuycar|
        if productbuycar.product_id == product_id && productbuycar.buycarparams.map{|n|[n.buyparam_id, n.buyparamvalue_id]}.sort == buyparams.sort
          productbuycar.destroy
          break
        end
      end
    else
      proprice = product.price
      shopusers = user.shopusers.where('member <> ?', 0)
      price = product.price
      proprice = product.proprice if product.proprice.to_f > 0 && shopusers.size > 0
      buyparams.each do |buyparam|
        buyparamvalue = Buyparamvalue.find_by(id: buyparam[1])
        if buyparamvalue
          price += buyparamvalue.price.to_f
          proprice += buyparamvalue.price.to_f
        end
      end
      if productbuycars.size > 0
        productbuycars.each do |productbuycar|
          if productbuycar.product_id == product_id && productbuycar.buycarparams.map{|n|[n.buyparam_id, n.buyparamvalue_id]}.sort == buyparams.sort
            if params[:type] == 'sum'
            productbuycar.update(number: number + productbuycar.number, price: product.price, proprice: proprice)
            else
              productbuycar.update(number: number, price: product.price, proprice: proprice)
            end
            break
          else
            buycar = user.buycars.create(number: number, product_id: product_id, price: price, proprice: proprice, producttype: 0)
            buyparams.each do |bp|
              buyparam = Buyparam.find_by(id: bp[0])
              buyparamvalue = Buyparamvalue.find_by(id: bp[1])
              if buyparam && buyparamvalue
                buycar.buycarparams.create(buyparam: buyparam.param, buyparam_id: bp[0], buyparamvalue: buyparamvalue.name, buyparamvalue_id: bp[1])
              end
            end
            changecover(buycar.id)
            break
          end
        end
      else
        buycar = user.buycars.create(number: number, product_id: product_id, price: price, proprice: proprice, producttype: 0)
        buyparams.each do |bp|
          buyparam = Buyparam.find_by(id: bp[0])
          buyparamvalue = Buyparamvalue.find_by(id: bp[1])
          if buyparam && buyparamvalue
            buycar.buycarparams.create(buyparam: buyparam.param, buyparam_id: bp[0], buyparamvalue: buyparamvalue.name, buyparamvalue_id: bp[1])
          end
        end
        changecover(buycar.id)
      end

    end

#修正一品多规格结束




    # if number <= 0
    #   buycar = buycars.where('product_id = ?', product_id).first
    #   buycar.destroy if buycar
    # else
    #   buyparams = []
    #   params[:datas][2].each do |f|
    #     if f.class == Array
    #       buyparams.push f
    #     end
    #   end
    #
    #   buycar = buycars.where('product_id = ?', product_id).first
    #
    #   proprice = product.price
    #   shopusers = user.shopusers.where('member <> ?', 0)
    #   price = product.price
    #   proprice = product.proprice if product.proprice.to_f > 0 && shopusers.size > 0
    #   buyparams.each do |buyparam|
    #     buyparamvalue = Buyparamvalue.find_by(id: buyparam[1])
    #     if buyparamvalue
    #       price += buyparamvalue.price.to_f
    #       proprice += buyparamvalue.price.to_f
    #     end
    #   end
    #   if buycar
    #     buycarparams = buycar.buycarparams.map{|n|[n.buyparam_id, n.buyparamvalue_id]}
    #     if buyparams.sort == buycarparams.sort
    #       buycar.update(number: number, price: product.price, proprice: proprice)
    #     else
    #       buycar = user.buycars.create(number: number, product_id: product_id, price: price, proprice: proprice, producttype: 0)
    #       buyparams.each do |bp|
    #         buyparam = Buyparam.find_by(id: bp[0])
    #         buyparamvalue = Buyparamvalue.find_by(id: bp[1])
    #         if buyparam && buyparamvalue
    #           buycar.buycarparams.create(buyparam: buyparam.param, buyparam_id: bp[0], buyparamvalue: buyparamvalue.name, buyparamvalue_id: bp[1])
    #         end
    #       end
    #     end
    #   else
    #     buycar = user.buycars.create(number: number, product_id: product_id, price: product.price, proprice: proprice, producttype: 0)
    #     buyparams.each do |bp|
    #       buyparam = Buyparam.find_by(id: bp[0])
    #       buyparamvalue = Buyparamvalue.find_by(id: bp[1])
    #       if buyparam && buyparamvalue
    #         buycar.buycarparams.create(buyparam: buyparam.param, buyparam_id: bp[0], buyparamvalue: buyparamvalue.name, buyparamvalue_id: bp[1])
    #       end
    #     end
    #   end
    #   cover = buycar.product.cover
    #   buycar.buycarparams.each do |f|
    #     buyparamvalue = Buyparamvalue.find_by(id: f.buyparamvalue_id)
    #     if buyparamvalue && buyparamvalue.cover.to_s.size > 0
    #       cover = buyparamvalue.cover
    #     end
    #   end
    #   buycar.update(cover: cover)
    # end
    buycararr = getbuycars(user.id,params[:shoudan].to_i, params[:chooseproprice].to_i, params[:shopid].to_i)
    return_api(buycararr)



  end

  private
  def getbuycars(userid, shoudan, chooseproprice, shopid)

    user = User.find(userid)
    buycars = user.buycars.where(producttype: 1)
    buycars.destroy_all
    Backrun.cal_shoudan(userid, shoudan, chooseproprice, shopid)
    buycars = user.buycars
    buycararr = []
    paysum = 0
    propricesum = 0
    buycars.each do |f|
      product = f.product
      buycar_param = {
          id: f.id,
          number: f.number,
          price: f.price,
          product_id: product.id,
          name: product.name,
          cover: f.cover,
          productcla_ids: product.productclas.ids,
          proprice: f.proprice,
          producttype: f.producttype.to_i,
          activesummary: f.activesummary.to_s,
          startnumber: product.startnumber.to_i,
          buyparams: f.buycarparams.map{|n|n.buyparam + ' ' + n.buyparamvalue}.join('  '),
          buycarparamids: f.buycarparams.map{|n|[n.buyparam_id, n.buyparamvalue_id]}
      }
      paysum += f.number.to_f * f.price.to_f
      propricesum += f.number.to_f * f.proprice.to_f
      buycararr.push buycar_param
    end
    param = {
        buycars: buycararr,
        paysum: paysum.round(2),
        propricesum: propricesum.round(2)
    }
    param
  end

  def changecover(buycarid)
    buycar = Buycar.find(buycarid)
    cover = buycar.product.cover
    buycar.buycarparams.each do |f|
      buyparamvalue = Buyparamvalue.find_by(id: f.buyparamvalue_id)
      if buyparamvalue && buyparamvalue.cover.to_s.size > 0
        cover = buyparamvalue.cover
      end
    end
    buycar.update(cover: cover)
  end
end

class EvaluatesumJob < ApplicationJob
  queue_as :default

  def perform(product_id)
    product = Product.find_by(id: product_id)
    if product
      if product.evaluates.size > 0
        speed = product.evaluates.average('speed').to_f
        quality = product.evaluates.average('quality').to_f
        describe = product.evaluates.average('describe').to_f
        comp = (speed + quality + describe) / 3
      else
        speed = 5
        quality = 5
        describe = 5
        comp = 5
      end
      product.update(speed: speed, quality: quality, describe: describe, comp: comp)
    end
  end
end

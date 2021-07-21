class Gencontract
  def self.testcontract
    uri = URI(Contracttemplate.all[0].contracttemplate.split('?')[0])
    response = Net::HTTP.get_response(uri)
    filename = "tmp/#{UUIDTools::UUID.timestamp_create.to_s.tr('-','')}.jpg"
      open(filename,"wb") { |file|
        file.write(response.body)
      }
    img = Magick::Image.read(filename).first
    my_text="MS20210709001"
    copyright = Magick::Draw.new
    copyright.annotate(img,0,0,730,390,my_text) do
    self.font = 'public/font/simsun.ttc'
      self.pointsize = 76
    end
    img.write(filename)
  end

  def self.contractdraft(shop_id, contractnumber, userid, contracttype, shopname, address)
    #page1
    uri = URI(Contracttemplate.all[0].contracttemplate.split('?')[0])
    response = Net::HTTP.get_response(uri)
    page1 = "tmp/#{UUIDTools::UUID.timestamp_create.to_s.tr('-','')}.jpg"
    open(page1,"wb") { |file|
      file.write(response.body)
    }
    img = Magick::Image.read(page1).first
    copyright = Magick::Draw.new
    copyright.annotate(img,0,0,750,390,contractnumber) do
      self.font = 'public/font/simsun.ttc'
      self.pointsize = 78
    end
    img.write(page1)
    #page1 end
    # page2
    uri = URI(Contracttemplate.all[1].contracttemplate.split('?')[0])
    response = Net::HTTP.get_response(uri)
    page2 = "tmp/#{UUIDTools::UUID.timestamp_create.to_s.tr('-','')}.jpg"
    open(page2,"wb") { |file|
      file.write(response.body)
    }
    img = Magick::Image.read(page2).first
    copyright = Magick::Draw.new
    copyright.annotate(img,0,0,468,578,shopname) do
      self.font = 'public/font/simsun.ttc'
      self.pointsize = 56
    end
    copyright.annotate(img,0,0,472,705,address) do
      self.font = 'public/font/simsun.ttc'
      self.pointsize = 56
    end
    copyright.annotate(img,0,0,520,2525,Time.now.strftime('%Y')) do
      self.font = 'public/font/simsun.ttc'
      self.pointsize = 56
    end
    copyright.annotate(img,0,0,810,2525,Time.now.strftime('%m')) do
      self.font = 'public/font/simsun.ttc'
      self.pointsize = 56
    end
    copyright.annotate(img,0,0,1080,2525,Time.now.strftime('%d')) do
      self.font = 'public/font/simsun.ttc'
      self.pointsize = 56
    end
    copyright.annotate(img,0,0,1435,2525,(Time.now + 3.years - 1.days).strftime('%Y')) do
      self.font = 'public/font/simsun.ttc'
      self.pointsize = 56
    end
    copyright.annotate(img,0,0,1730,2525,(Time.now + 3.years - 1.days).strftime('%m')) do
      self.font = 'public/font/simsun.ttc'
      self.pointsize = 56
    end
    copyright.annotate(img,0,0,1995,2525,(Time.now + 3.years - 1.days).strftime('%d')) do
      self.font = 'public/font/simsun.ttc'
      self.pointsize = 56
    end
    copyright.annotate(img,0,0,605,2655,'3') do
      self.font = 'public/font/simsun.ttc'
      self.pointsize = 56
    end
    img.write(page2)
    #page2 end
    # page3
    uri = URI(Contracttemplate.all[2].contracttemplate.split('?')[0])
    response = Net::HTTP.get_response(uri)
    page3 = "tmp/#{UUIDTools::UUID.timestamp_create.to_s.tr('-','')}.jpg"
    open(page3,"wb") { |file|
      file.write(response.body)
    }
    #page3 end
    # page4
    uri = URI(Contracttemplate.all[3].contracttemplate.split('?')[0])
    response = Net::HTTP.get_response(uri)
    page4 = "tmp/#{UUIDTools::UUID.timestamp_create.to_s.tr('-','')}.jpg"
    open(page4,"wb") { |file|
      file.write(response.body)
    }
    #page4 end
    user = User.find(userid)
    contract = user.contracts.create(shop_id: shop_id, status: 0)
    resource = Resource.create(resource: open(page1))
    contract.contractdetails.create(contractimg: Rails.configuration.serverurl + resource.resource.url)
    resource = Resource.create(resource: open(page2))
    contract.contractdetails.create(contractimg: Rails.configuration.serverurl + resource.resource.url)
    resource = Resource.create(resource: open(page3))
    contract.contractdetails.create(contractimg: Rails.configuration.serverurl + resource.resource.url)
    resource = Resource.create(resource: open(page4))
    contract.contractdetails.create(contractimg: Rails.configuration.serverurl + resource.resource.url)
    if FileTest::exist?(page1)
      File.delete(page1)
    end
    if FileTest::exist?(page2)
      File.delete(page2)
    end
    if FileTest::exist?(page3)
      File.delete(page3)
    end
    if FileTest::exist?(page4)
      File.delete(page4)
    end
  end

  def self.createsign(imgurl, shopid)
    uri = URI(Contracttemplate.all[3].contracttemplate.split('?')[0])
    response = Net::HTTP.get_response(uri)
    pageback = "tmp/#{UUIDTools::UUID.timestamp_create.to_s.tr('-','')}.jpg"
    open(pageback,"wb") { |file|
      file.write(response.body)
    }
    uri = URI(imgurl.split('?')[0])
    response = Net::HTTP.get_response(uri)
    pagewater = "tmp/#{UUIDTools::UUID.timestamp_create.to_s.tr('-','')}.png"
    open(pagewater,"wb") { |file|
      file.write(response.body)
    }
    imgback = Magick::Image.read(pageback).first
    imgwater = Magick::Image.read(pagewater).first
    imgwater.resize!(375,190)
    imgback.composite!(imgwater, 450, 920, Magick::DarkenCompositeOp)
    imgback.write(pageback)
    resource = Resource.create(resource: open(pageback))
    shop = Shop.find(shopid)
    shop.contracts.first.contractdetails.last.update(contractimg: Rails.configuration.serverurl + resource.resource.url)
    if FileTest::exist?(pagewater)
      File.delete(pagewater)
    end
    if FileTest::exist?(pageback)
      File.delete(pageback)
    end
  end
end
class Api::InvoicedefsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    invoicedefs = user.invoicedefs
    invoicedefarr = []
    invoicedefs.each do |f|
      invoicetype = ''
      invoicetype = '增值税普通发票' if f.invoicetype == 1
      invoicetype = '增值税专用发要票' if f.invoicetype == 2
      invoicedef_param = {
          id: f.id,
          name: f.name,
          invoicetype: invoicetype,
          isdefault: f.isdefault.to_i
      }
      invoicedefarr.push invoicedef_param
    end
    return_api(invoicedefarr)
  end

  def createinvoice
    user = User.find_by_token(params[:token])
    invoicedef = user.invoicedefs.create(
        invoicetype: params[:invoicetype],
        name: params[:name],
        duty: params[:duty],
        address: params[:address],
        tel: params[:tel],
        bank: params[:bank],
        account: params[:account],
        mail: params[:mail],
        isdefault: 0
        )
    defaultsize = user.invoicedefs.where(isdefault: 1).size
    if defaultsize == 0
      invoicedef.update(isdefault: 1)
    end
    return_api('')
  end

  def setdefault
    user = User.find_by_token(params[:token])
    invoicedef = Invoicedef.find(params[:invoicedef_id])
    invoicedefs = user.invoicedefs
    Invoicedef.transaction do
      invoicedefs.each do |f|
        if f.id == invoicedef.id
          f.update(isdefault: 1)
        else
          f.update(isdefault: 0)
        end
      end
    end
    return_api('')
  end

  def getinvoice
    invoicedef = Invoicedef.find(params[:invoice_id])
    param = {
        id: invoicedef.id,
        name: invoicedef.name,
        duty: invoicedef.duty,
        address: invoicedef.address,
        tel: invoicedef.tel,
        bank: invoicedef.bank,
        account: invoicedef.account,
        mail: invoicedef.mail,
        invoicetype: invoicedef.invoicetype
    }
    return_api(param)
  end

  def updateinvoice
    invoicedef = Invoicedef.find(params[:invoice_id])
    invoicedef.update(
        invoicetype: params[:invoicetype],
        name: params[:name],
        duty: params[:duty],
        address: params[:address],
        tel: params[:tel],
        bank: params[:bank],
        account: params[:account],
        mail: params[:mail]
    )
    return_api('')
  end

  def deleteinvoice
    user = User.find_by_token(params[:token])
    invoicedef = Invoicedef.find(params[:invoice_id])
    invoicedef.destroy
    defaultinvoice = user.invoicedefs.where(isdefault: 1).first
    if !defaultinvoice
      firstinvoice = user.invoicedefs.first
      if firstinvoice
        firstinvoice.update(isdefault: 1)
      end
    end
    return_api('')
  end
end

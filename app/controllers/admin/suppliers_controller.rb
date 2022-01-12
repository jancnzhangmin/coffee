class Admin::SuppliersController < ApplicationController
  def index
    suppliers = Supplier.all.order('id desc')
    supplierarr = []
    suppliers.each do |f|
      supplier_param = {
          id: f.id,
          name: f.name,
          contact: f.contact,
          tel: f.tel,
          address: f.address
      }
      supplierarr.push supplier_param
    end
    return_res(supplierarr)
  end

  def create
    data = JSON.parse(params[:data])
    Supplier.create(
        name: data["name"],
        contact: data["contact"],
        address: data["address"],
        tel: data["tel"],
        invoicename: data["invoicename"],
        invoiceduty: data["invoiceduty"],
        invoiceaddress: data["invoiceaddress"],
        invoicetel: data["invoicetel"],
        invoicebank: data["invoicebank"],
        invoiceaccount: data["invoiceaccount"],
        firstorder: data["firstorder"],
        renewalorder: data["renewalorder"]
    )
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    supplier = Supplier.find(params[:id])
    supplier.update(
        name: data["name"],
        contact: data["contact"],
        address: data["address"],
        tel: data["tel"],
        invoicename: data["invoicename"],
        invoiceduty: data["invoiceduty"],
        invoiceaddress: data["invoiceaddress"],
        invoicetel: data["invoicetel"],
        invoicebank: data["invoicebank"],
        invoiceaccount: data["invoiceaccount"],
        firstorder: data["firstorder"],
        renewalorder: data["renewalorder"]
    )
    return_res('')
  end

  def show
    supplier = Supplier.find(params[:id])
    supplier_param = {
        id: supplier.id,
        name: supplier.name,
        contact: supplier.contact,
        address: supplier.address,
        tel: supplier.tel,
        invoicename: supplier.invoicename,
        invoiceduty: supplier.invoiceduty,
        invoiceaddress: supplier.invoiceaddress,
        invoicetel: supplier.invoicetel,
        invoicebank: supplier.invoicebank,
        invoiceaccount: supplier.invoiceaccount,
        firstorder: supplier.firstorder,
        renewalorder: supplier.renewalorder
    }
    return_res(supplier_param)
  end

  def destroy
    supplier = Supplier.find(params[:id])
    supplier.destroy
    return_res('')
  end
end

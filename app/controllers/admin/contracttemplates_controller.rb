class Admin::ContracttemplatesController < ApplicationController
  def index
    contracttemplates = Contracttemplate.all
    total = contracttemplates.size
    contracttemplatearr = []
    contracttemplates.each do |f|
      contracttemplate_param = {
          id: f.id,
          contracttemplate: f.contracttemplate
      }
      contracttemplatearr.push contracttemplate_param
    end
    param = {
        total: total,
        data: contracttemplatearr
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    contracttemplate = Contracttemplate.create(contracttemplate: data["contracttemplate"])
    return_res('')
  end

  def update
    data = JSON.parse(params[:data])
    contracttemplate = Contracttemplate.find(params[:id])
    contracttemplate.update(contracttemplate: data["contracttemplate"])
    return_res('')
  end

  def destroy
    contracttemplate = Contracttemplate.find(params[:id])
    contracttemplate.destroy
    return_res('')
  end
end

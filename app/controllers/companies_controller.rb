class CompaniesController < ApplicationController
  def list
    @list_table = Company.all
    @columns = ["name", "address", "tax_id", "tel"]
    render 'share/list'
    end

def index
    redirect_to(:action => 'list')
end

 def new
    @fields = ["name", "address", "tax_id", "tel"]
    @item = Company.new
    @form_action = "create"
    render 'share/item'
  end

def create
    @item = Company.create(item_params)
    if @item.save then
        flash[:notice] = "Company fue creado con exito"
        redirect_to(:action => 'list')
    else
        render('new')
    end
end

  def show
    @fields = ["name", "address", "tax_id", "tel"]
    @item = Company.find(params[:id])
    @form_action = "update"
    render 'share/item'
  end

  def update
      @item = Company.find(params[:id])
      if @item.update_attributes(item_params)
          redirect_to(:action => 'list')
    else
        render('edit')
    end
  end

def delete
    item = Company.find(params[:id])
    item.destroy
    flash[:notice] = 'Company fue eliminado con exito'
    redirect_to(:action => 'list')
end


  private
  
  def item_params
      params.require(:item).permit(:name, :address, :tax_id, :tel)
  end
end

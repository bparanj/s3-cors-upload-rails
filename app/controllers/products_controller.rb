class ProductsController < ApplicationController

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(permitted_params)
    
    if @product.save
      redirect_to root_path, :notice => "Upload was successful."
    else
      render :new
    end
  end

  private
  
  def permitted_params
    params.require(:product).permit(:name, :price, :url)
  end
end

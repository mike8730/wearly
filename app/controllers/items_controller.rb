class ItemsController < ApplicationController
  def index
  end
    def new
     @item_form = ItemForm.new
     @item_form.item_variants_attributes = { "0" => { size_id: "", color_id: "", stock_quantity: "", price: "" } }
  end
  
  def create
    @item_form = ItemForm.new(item_params.except(:item_variants_attributes))

    if item_params[:item_variants_attributes].present?
      @item_form.item_variants_attributes = item_params[:item_variants_attributes]
    end

    if @item_form.save
      redirect_to root_path, notice: "商品を出品しました"
    else
      render :new
    end
  end


  private

  def item_params
    params.require(:item_form).permit(
      :name,
      :price,
      :description,
      :category_id,
      :gender_id,
      images: [],
      item_variants_attributes: [:id, :size_id, :color_id, :stock_quantity, :price, :_destroy]
    )
  end
end

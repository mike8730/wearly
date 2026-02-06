class ItemsController < ApplicationController
  def index
    @items = Item.order(created_at: :desc)
  end

  def new
    @item_form = ItemForm.new
    @item_form.item_variants_attributes = [
      { size_id: "", color_id: "", stock_quantity: "", price: "" } 
      ]
  end
  
  def create
    @item_form = ItemForm.new(item_params)

    if @item_form.save
      redirect_to root_path, notice: "商品を出品しました"
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
    @item_colors = @item.item_colors
    
    if params[:color_id].present?
      @item_color = @item_colors.find_by(color_id: params[:color_id])
      @item_variants = @item_color.item_variants if @item_color
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
      item_variants_attributes: [:id, :size_id, :color_id, :stock_quantity, :price,:_destroy, { color_images: [] }]
    )
  end
end

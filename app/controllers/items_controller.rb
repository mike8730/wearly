class ItemsController < ApplicationController
  def index
    @items = Item
      .includes(item_colors: { images_attachments: :blob })
      .includes(:item_variants)
      .order(created_at: :desc)
  end

  def new
    @item_form = ItemForm.new
  end

  def create
    @item_form = ItemForm.new(item_params)

    if @item_form.valid?
      @item_form.save!(variant_params)
      redirect_to root_path, notice: "商品を出品しました"
    else
      render :new, status: :unprocessable_content
    end

  rescue => e
    Rails.logger.error("Create failed: #{e.class} - #{e.message}")
    render :new, status: :unprocessable_content
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
      :description,
      :category_id,
      :gender_id,
      :price
    )
  end

  def variant_params
    params[:variant_forms]&.values || []
  end
end

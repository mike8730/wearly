class OrdersController < ApplicationController
  def new
    @item_variant = ItemVariant.find(params[:variant_id])
    @order_form = OrderForm.new(
      user_id: current_user.id,
      item_variant_id: @item_variant.id
    )
    @item = @item_variant.item
  end

  def create
    @order_form = OrderForm.new(order_form_params)
    if @order_form.save
      redirect_to root_path, notice: "注文が完了しました。"
    else 
      @item_variant = ItemVariant.find(order_form_params[:item_variant_id])
      @item = @item_variant.item
      render :new, status: :unprocessable_entity
    end
  end

  private
  def order_form_params
    params.require(:order_form).permit(
      :item_variant_id,
      :postal_code,
      :city,
      :address,
      :phone_number,
      :prefecture_id,
      order_items_attributes: [:item_variant_id, :quantity]
    ).merge(user_id: current_user.id)
  end
end

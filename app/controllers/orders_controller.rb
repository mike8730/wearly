class OrdersController < ApplicationController
  def new
    @order_form = OrderForm.new
  end

  def create
    @order_form = OrderForm.new(order_form_params)
    if @order_form.save
      redirect_to root_path, notice: "注文が完了しました。"
    else 
      render :new, status: :unprocessable_entity
    end
  end

  private
  def order_form_params
    params.require(:order_form).permit(
      :postal_code,
      :city,
      :address,
      :phone_number,
      :prefecture_id,
      order_items_attributes: [:item_variant_id, :quantity]
    )
  end
end

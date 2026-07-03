class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @item = Item.find(params[:item_id])
    current_user.favorites.create(item: @item)
    render json: { status: "ok" }
  end

  def destroy
    @item = Item.find(params[:item_id])
    current_user.favorites.find_by(item: @item)&.destroy
    render json: { status: "ok" }
  end
end
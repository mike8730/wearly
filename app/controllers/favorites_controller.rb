class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorite_items = current_user.favorite_items
                      .includes(:favorites)
                      .order('favorites.created_at DESC')
  end

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
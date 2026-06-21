class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @item = Item.find(params[:item_id])
    current_user.favorites.create(item: @item)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to item_path(@item) }
    end
  end

  def destroy
    @item = Item.find(params[:item_id])
    current_user.favorites.find_by(item: @item)&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to item_path(@item) }
    end
  end
end
class CoordinatesController < ApplicationController
  def new
    @coordinate = Coordinate.new
    @coordinate.coordinate_items.build
  end

  def create
    @coordinate = Coordinate.new(coordinate_params)
    
    if @coordinate.save
      redirect_to @coordinate, notice: "コーディネートを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @coordinates = Coordinate.order(created_at: :desc)
  end

  private
  def coordinate_params
    params.require(:coordinate).permit(
      :name,
      :description,
      :image,
      coordinate_items_attributes: [:id, :item_id, :_destroy]
    )
  end
end

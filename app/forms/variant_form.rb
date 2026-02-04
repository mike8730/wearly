class VariantForm
  include ActiveModel::Model

  attr_accessor :size_id, :color_id, :stock_quantity, :price, :color_images

  validates :size_id, :color_id, :stock_quantity, :price, presence: true

  # ItemVariant に渡すのは size / stock / price のみ
  def attributes
    {
      size_id: size_id.to_i,
      stock_quantity: stock_quantity.to_i,
      price: price.to_i
    }
  end
end

class VariantForm
  include ActiveModel::Model

  attr_accessor :size_id, :color_id, :stock_quantity, :price,
                :color_images, :_destroy

  # ★ price の presence: true を削除する
  validates :size_id, :color_id, :stock_quantity, presence: true

  def color_images
    Array(@color_images)
  end

  # ItemVariant に渡すのは size / stock / price のみ
  def attributes
    {
      size_id: size_id.to_i,
      stock_quantity: stock_quantity.to_i,
      price: price.to_i
    }
  end
end

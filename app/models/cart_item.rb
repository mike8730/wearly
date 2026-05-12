class CartItem < ApplicationRecord
  validates :quantity, numericality: { greater_than: 0 }

  belongs_to :item_variant
  belongs_to :cart

  def subtotal
    item_variant.price * quantity
  end
end

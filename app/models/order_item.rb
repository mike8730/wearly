class OrderItem < ApplicationRecord
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  
  belongs_to :order
  belongs_to :item_variant
end

class ItemVariant < ApplicationRecord
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than: 0 }
  
  has_many_attached :images
  has_many :cart_items, dependent: :destroy
  belongs_to :item
  belongs_to :size
  belongs_to :color
end

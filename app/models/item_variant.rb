class ItemVariant < ApplicationRecord
  validates :item_id, presence: true
  validates :size_id, presence: true
  validates :color_id, presence: true
  validates :stock_quantity, presence: true
  validates :price, presence: true

  belongs_to :item
  belongs_to :size
  belongs_to :color
end

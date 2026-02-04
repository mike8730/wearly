class ItemColor < ApplicationRecord
  belongs_to :color
  belongs_to :item

  has_many :item_variants, dependent: :destroy 
  has_many_attached :images
end

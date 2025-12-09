class Size < ApplicationRecord
  validates :name, presence: true
  has_many :item_variants
end

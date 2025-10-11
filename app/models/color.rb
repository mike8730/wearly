class Color < ApplicationRecord
  validates :name, presence: true
  has_many :item_variants
end

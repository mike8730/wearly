class Color < ApplicationRecord
  validates :name, presence: true
  
  has_many :item_colors, dependent: :destroy
  has_many :item_variants, through: :item_colors
end
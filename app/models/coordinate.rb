class Coordinate < ApplicationRecord
  has_many :coordinate_items, dependent: :destroy
  has_many :items, through: :coordinate_items

  has_one_attached :image

  accepts_nested_attributes_for :coordinate_items, allow_destroy: true

  validates :name, presence: true
end

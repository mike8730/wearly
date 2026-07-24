class Item < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :description, presence: true
  validates :product_category_id, presence: true
  validates :gender_id, presence: true, numericality: { other_than: 0 }

  extend ActiveHash::Associations::ActiveRecordExtensions

  has_many :item_colors, dependent: :destroy
  has_many :item_variants, through: :item_colors

  has_many :colors, through: :item_colors
  has_many :sizes, through: :item_variants

  has_many_attached :images

  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user

  has_many :coordinate_items, dependent: :destroy
  has_many :coordinates, through: :coordinate_items

  belongs_to :product_category
  belongs_to_active_hash :gender
end

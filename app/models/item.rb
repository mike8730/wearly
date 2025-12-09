class Item < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :description, presence: true
  validates :category_id, presence: true, numericality: { other_than: 0 }
  validates :gender_id, presence: true, numericality: { other_than: 0 }

  extend ActiveHash::Associations::ActiveRecordExtensions
  has_many :item_variants, dependent: :destroy
  has_many :colors, through: :item_variants
  has_many :sizes, through: :item_variants
  has_many_attached :images
  belongs_to_active_hash :category
  belongs_to_active_hash :gender
end

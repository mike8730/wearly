class Color < ApplicationRecord
  validates :name, presence: true
  has_many :item_variants
  has_many_attached :images

  validate :must_have_at_least_one_image, on: :create

  def must_have_at_least_one_image
    errors.add(:images, "を1枚以上登録してください") unless images.attached?
  end
end

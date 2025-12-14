class ShippingAddress < ApplicationRecord
  validates :postal_code, presence: true, format: { with: /\A\d{3}-\d{4}\z/ }
  validates :city, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{10,11}\z/ }
  validates :prefecture_id, presence: true, numericality: { other_than: 0}
  
  belongs_to :order
  belongs_to_active_hash :prefecture
end

class Order < ApplicationRecord
  validates :status, presence: true
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum status: {
    pending: 'pending',
    paid: 'paid',
    shipped: 'shipped',
    cancelled: 'cancelled'   
  }

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_one :shipping_address, dependent: :destroy
end

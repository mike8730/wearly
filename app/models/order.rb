class Order < ApplicationRecord
  validates :status, presence: true
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum status: {
    pending: 0,
    paid: 1,
    shipped: 2,
    cancelled: 3   
  }

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_one :shipping_address, dependent: :destroy

  def calculate_total_price
    order_items.sum { |oi| oi.price * oi.quantity }
  end
end

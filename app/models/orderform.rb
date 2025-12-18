class OrderForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :postal_code, :city, :address, :phone_number, :prefecture_id
  attr_accessor :order_items_attributes
  
  validates :postal_code, presence: true, format: { with: /\A\d{3}-\d{4}\z/ }
  validates :city, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{10,11}\z/ } 
  validates :prefecture_id, presence: true, numericality: { other_than: 0 }

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      order = Order.create!

      ShippingAddress.create!(
        order: order,
        postal_code: postal_code,
        city: city,
        address: address,
        phone_number: phone_number,
        prefecture_id: prefecture_id
      )

      order_items_attributes.each do |item_attr|
        OrderItem.create!(
          order: order,
          item_variant_id: item_attr[:item_variant_id],
          quantity: item_attr[:quantity]
        )
      end
    end

    true
  rescue ActiveRecord::RecordInvalid
    false  
  end
end
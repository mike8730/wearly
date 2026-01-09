class OrderForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :postal_code, :city, :address, :phone_number, :prefecture_id
  attr_accessor :order_items_attributes
  attr_accessor :user_id, :item_variant_id
  
  validates :postal_code, presence: true, format: { with: /\A\d{3}-\d{4}\z/ }
  validates :city, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{10,11}\z/ } 
  validates :prefecture_id, presence: true, numericality: { other_than: 0 }
  validates :user_id, presence: true
  validates :item_variant_id, presence: true

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      order = Order.create!(user_id: user_id)

      ShippingAddress.create!(
        order: order,
        postal_code: postal_code,
        city: city,
        address: address,
        phone_number: phone_number,
        prefecture_id: prefecture_id
      )
      
      if order_items_attributes.present?
        Array(order_items_attributes).each do |item_attr|
          OrderItem.create!(
            order: order,
            item_variant_id: item_attr[:item_variant_id],
            quantity: item_attr[:quantity]
          )
        end
      else
        OrderItem.create!(
          order: order,
          item_variant_id: item_variant_id,
          quantity: 1
        )
      end
    end

    true
  rescue ActiveRecord::RecordInvalid
    false  
  end
end
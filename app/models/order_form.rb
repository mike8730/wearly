class OrderForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :postal_code, :city, :address, :phone_number, :prefecture_id
  attr_accessor :order_items_attributes
  attr_accessor :user_id, :item_variant_id
  attr_accessor :payment_method
  
  validates :postal_code, presence: true, format: { with: /\A\d{3}-\d{4}\z/ }
  validates :city, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{10,11}\z/ } 
  validates :prefecture_id, presence: true, numericality: { other_than: 0 }
  validates :user_id, presence: true
  validates :item_variant_id, presence: true
  validates :payment_method, presence: true

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      order = Order.create!(user_id: user_id, payment_method: payment_method, total_price: 0)

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
          variant = ItemVariant.find(item_attr[:item_variant_id])
          OrderItem.create!(
            order: order,
            item_variant_id: item_attr[:item_variant_id],
            quantity: item_attr[:quantity],
            price: variant.price
          )
        end
      else
        variant = ItemVariant.find(item_variant_id)
        OrderItem.create!(
          order: order,
          item_variant_id: item_variant_id,
          quantity: 1,
          price: variant.price
        )
      end

      order.update!(
        total_price: order.calculate_total_price
      )

    end

    true
  rescue ActiveRecord::RecordInvalid
    false  
  end
end
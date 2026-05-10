class OrderForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :postal_code, :city, :address, :building, :phone_number, :prefecture_id
  attr_accessor :order_items_attributes
  attr_accessor :user_id
  attr_accessor :payment_method
  
  validates :postal_code, presence: true, format: { with: /\A\d{3}-\d{4}\z/ }
  validates :city, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{10,11}\z/ }
  validates :prefecture_id, presence: true, numericality: { other_than: 0 }
  validates :user_id, presence: true
  validates :payment_method, presence: true

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      order = Order.create!(
        user_id: user_id,
        payment_method: payment_method,
        total_price: 0,
        status: :pending
      )

      ShippingAddress.create!(
        order: order,
        postal_code: postal_code,
        city: city,
        address: address,
        building: building,
        phone_number: phone_number,
        prefecture_id: prefecture_id
      )

      Array(order_items_attributes).each do |item_attr|
        variant = ItemVariant.find(item_attr[:item_variant_id])
        
        if variant.stock_quantity < item_attr[:quantity]
          errors.add(:base, "#{variant.item.name}の在庫が不足しています。")
          raise ActiveRecord::RecordInvalid.new(self)
        end

        variant.update!(stock_quantity: variant.stock_quantity - item_attr[:quantity])

        OrderItem.create!(
          order: order,
          item_variant_id: item_attr[:item_variant_id],
          quantity: item_attr[:quantity],
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
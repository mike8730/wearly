class OrderForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :postal_code, :city, :address, :building, :phone_number, :prefecture_id
  attr_accessor :order_items_attributes
  attr_accessor :user_id
  attr_accessor :payment_provider_type
  attr_accessor :payment_uuid
  attr_reader :order

  validates :postal_code, presence: true, format: { with: /\A\d{3}-\d{4}\z/ }
  validates :city, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{10,11}\z/ }
  validates :prefecture_id, presence: true, numericality: { other_than: 0 }
  validates :user_id, presence: true

  def initialize(attributes = {})
    super
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      @order = Order.create!(
        user_id: user_id,
        payment_provider_type: payment_provider_type,
        payment_uuid: payment_uuid,
        total_price: 0,
        status: :paid
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

      order.update!(total_price: order.calculate_total_price)
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
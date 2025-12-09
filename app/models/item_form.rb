class ItemForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :name, :price, :description, :category_id, :gender_id, :images
  attr_reader :item_variants_attributes, :variants

  validates :name, :price, :description, :category_id, :gender_id, presence: true
  validate :variants_presence

  def item_variants_attributes=(attributes)
    @variants = attributes.to_h.map do |_, variant_params|
      VariantForm.new(variant_params)
    end
  end

  def item_variants
    @variants
  end


  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      item = Item.create!(
        name: name,
        price: price,
        description: description,
        category_id: category_id,
        gender_id: gender_id
      )

      item.images.attach(images) if images.present?

      @variants.each do |variant_form|
        variant = item.item_variants.create!(variant_form.attributes)
        variant.images.attach(variant_form.images) if variant_form.images.present?
      end
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("保存失敗: #{e.record.class.name} - #{e.record.errors.full_messages}")
    false
  end
end


  private
  def variants_presence
    errors.add(:base, "SKUを１つ以上入力してください") if @variants.blank?
  end

class VariantForm
  include ActiveModel::Model

  attr_accessor :size_id, :color_id, :stock_quantity, :price, :images
  validates :size_id, :color_id, :stock_quantity, :price, presence: true

  def attributes
    {
      size_id: size_id.to_i,
      color_id: color_id.to_i,
      stock_quantity: stock_quantity.to_i,
      price: price.to_i
    }
  end
end

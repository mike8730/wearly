class ItemForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :name, :price, :description, :category_id, :gender_id
  attr_reader :variants

  validates :name, :price, :description, :category_id, :gender_id, presence: true
  validate :variants_presence

  # SKU の配列を受け取る
  def item_variants_attributes=(attributes)
    @variants = attributes.to_h.map do |_, variant_params|
      VariantForm.new(variant_params)
    end
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      # ① Item を作成
      item = Item.create!(
        name: name,
        price: price,
        description: description,
        category_id: category_id,
        gender_id: gender_id
      )

      # ② 各 VariantForm を処理
      @variants.each do |variant_form|
        next if variant_form._destroy == "1"  # ← これが必須

        item_color = ItemColor.find_or_create_by!(
          item_id: item.id,
          color_id: variant_form.color_id
        )

        if variant_form.color_images.present?
          item_color.images.attach(variant_form.color_images)
        end

        item_color.item_variants.create!(
          size_id: variant_form.size_id,
          stock_quantity: variant_form.stock_quantity,
          price: variant_form.price
        )
      end
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("保存失敗: #{e.record.class.name} - #{e.record.errors.full_messages}")
    false
  end

  private

  def variants_presence
    errors.add(:base, "SKUを１つ以上入力してください") if @variants.blank?
  end
end
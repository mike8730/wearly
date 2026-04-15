class ItemForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :name, :price, :description, :category_id, :gender_id
  attr_reader :item_variants

  validates :name, :price, :description, :category_id, :gender_id, presence: true
  validate :variants_presence

  # ネストした attributes を受け取る
  def item_variants_attributes=(attributes)
    @item_variants = attributes.to_h.map do |_, variant_params|
      next unless variant_params.is_a?(Hash)  # ★ 空行（String）を除外
      VariantForm.new(variant_params)
    end.compact
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
      item_variants.each do |variant_form|
      # ★ color_id が空の行は絶対に保存しない（これが決定打）
        next if variant_form.color_id.blank?

        next if variant_form._destroy == "1"

        item_color = ItemColor.find_or_create_by!(
          item_id: item.id,
          color_id: variant_form.color_id
        )

        if variant_form.color_images.present?
          item_color.images.attach(variant_form.color_images)
        end

        variant_price =
          if variant_form.price.present?
            variant_form.price.to_i
          else
            price.to_i
          end

        item_color.item_variants.create!(
          item_id: item.id,                     # ★ 追加
          color_id: variant_form.color_id,      # ★ 追加
          size_id: variant_form.size_id,
          stock_quantity: variant_form.stock_quantity,
          price: variant_price
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
    errors.add(:base, "SKUを１つ以上入力してください") if item_variants.blank?
  end
end
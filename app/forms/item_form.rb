class ItemForm
  include ActiveModel::Model

  attr_accessor :name,
                :description,
                :category_id,
                :gender_id,
                :price

  validates :name, :price, :category_id, :gender_id, presence: true

  def save!(variant_params)
    ActiveRecord::Base.transaction do
      item = Item.create!(
        name: name,
        description: description,
        category_id: category_id,
        gender_id: gender_id,
        price: price
      )

      Array(variant_params).each do |variant|
        next if variant[:color_id].blank?
        next if variant[:size_id].blank?
        next if variant[:stock_quantity].blank?

        color = ItemColor.create!(
          item: item,
          color_id: variant[:color_id]
        )

        Array(variant[:color_images])
          .reject(&:blank?)
          .each do |image|
            color.images.attach(image)
          end

        ItemVariant.create!(
          item: item,
          item_color: color,
          size_id: variant[:size_id],
          stock_quantity: variant[:stock_quantity],
          price: variant[:price].presence || price
        )
      end
    end
  end
end

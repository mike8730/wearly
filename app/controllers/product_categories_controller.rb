class ProductCategoriesController < ApplicationController
  def index
    @product_categories = ProductCategory.all
  end

  def show
    @product_category = ProductCategory
                          .includes(
                            items: [
                              { item_colors: { images_attachments: :blob } },
                              :item_variants,
                              :favorites
                            ]
                          )
                          .find(params[:id])

    @category_items = @product_category.items
  end
end

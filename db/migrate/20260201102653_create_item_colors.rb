class CreateItemColors < ActiveRecord::Migration[7.1]
  def change
    create_table :item_colors do |t|

      t.timestamps
    end
  end
end

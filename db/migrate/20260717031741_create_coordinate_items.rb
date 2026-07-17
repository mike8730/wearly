class CreateCoordinateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :coordinate_items do |t|
      t.references :item, null: false, foreign_key: true
      t.references :coordinate, null: false, foreign_key: true
      t.timestamps
    end
  end
end

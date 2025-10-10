class CreateItems < ActiveRecord::Migration[7.1]
   def change
    create_table :items do |t|
      t.string   :name,        null:false
      t.integer  :price,       null: false 
      t.text     :description, null: false
      t.integer  :category_id, null: false
      t.integer  :gender_id,   null: false
      t.timestamps
    end
  end
end

class CreateColors < ActiveRecord::Migration[7.1]
  def change
    create_table :colors do |t|
      t.timestamps
      t.string :name, null: false
      t.string :code
    end
  end
end

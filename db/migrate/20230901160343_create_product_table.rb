class CreateProductTable < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :price
      t.text :description
      t.jsonb :tags

      t.timestamps
    end
  end
end

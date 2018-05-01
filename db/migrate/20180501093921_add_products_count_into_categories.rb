class AddProductsCountIntoCategories < ActiveRecord::Migration[5.2]
  def change
    change_table :categories do |t|
      t.integer :products_count, null: false, default: 0
    end
  end
end

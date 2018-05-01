[
  {
    name: 'Food', products: [{name: 'apple', price: 2.5}, {name: 'water', price: 1.3}]
  },

  {
    name: 'Books', products: [{name: '1984', price: 1000}, {name: 'Karl Marx capital', price: 540}]
  },

  {
    name: 'Cars', products: [{name: 'Lada Granta', price: 400_000}, {name: 'Renault Logan', price: 540_000}]
  }
].each do |category_attrs|
  category = Category.find_or_create_by!(name: category_attrs[:name])
  category_attrs[:products].each do |product_attrs|
    Product.find_or_create_by!(category: category, name: product_attrs[:name]) do |product|
      product.price = product_attrs[:price]
    end
  end
end
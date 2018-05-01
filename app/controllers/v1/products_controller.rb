class V1::ProductsController < ResourcesController
  private
  
  def permitted_attributes
    [:category_id, :name, :price]
  end
end
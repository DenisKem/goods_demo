class V1::ProductsController < ResourcesController
  private
  
  def permitted_attributes
    super + [:category_id, :name, :price]
  end
end
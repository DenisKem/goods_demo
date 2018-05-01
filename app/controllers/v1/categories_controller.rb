class V1::CategoriesController < ResourcesController
  private

  def permitted_attributes
    super + [:name]
  end  
end

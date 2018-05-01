class ResourcesController < ApplicationController
  def index
    resources = resource_model.ransack(params[:q]).result
    render json: resources
  end

  def create
    resource = resource_model.new(resource_params_for_create)
    
    if resource.save
      render json: resource, status: :created      
    else
      render json: {errors: resource.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    resource = resource_model.find(params[:id])

    resource.destroy
    render json: {}
  end

  private
  
  def resource_model
    underscored_model_name.capitalize.constantize
  end

  def resource_params_for_create
    params.require(underscored_model_name).permit(permitted_attributes_for_create)
  end

  def permitted_attributes
    []
  end

  def permitted_attributes_for_create
    permitted_attributes
  end

  def underscored_model_name
    controller_name.delete_suffix('Controller').singularize 
  end
end
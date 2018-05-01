class ResourcesController < ApplicationController
  def index
    resources = resource_model.all
    render json: resources
  end

  private

  def resource_model
    controller_name.delete_suffix('Controller').singularize.capitalize.constantize
  end
end
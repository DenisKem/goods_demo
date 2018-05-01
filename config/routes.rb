Rails.application.routes.draw do
  scope :api, defaults: {format: :json} do
    namespace :v1 do
      resources :categories, only: [:index, :create]
      resources :products, only: [:index, :create, :destroy]
    end
  end
end

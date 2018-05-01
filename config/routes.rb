Rails.application.routes.draw do
  scope :api,  defaults: {format: :json} do
    namespace :v1 do
      resources :categories
    end
  end
end

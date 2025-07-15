Rails.application.routes.draw do
  root "api#index"
  post "/login", to: "auth#login"
  resources :users, only: [:index, :show, :create]
  resources :photos, only: [:index, :show, :create, :update, :destroy]
end
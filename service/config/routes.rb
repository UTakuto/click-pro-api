Rails.application.routes.draw do
  post "/login", to: "auth#login"
  resources :users, only: [:index, :show, :create]
  resources :photos, only: [:index, :create]
end
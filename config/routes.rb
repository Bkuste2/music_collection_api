Rails.application.routes.draw do
  resources :albums
  resources :users
  post 'auth/login', to: 'auth#login'
end

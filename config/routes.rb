Rails.application.routes.draw do
  resources :artists
  resources :users
  resources :albums
  post 'auth/login', to: 'auth#login'
  get 'auth/profile', to: 'auth#profile'
end

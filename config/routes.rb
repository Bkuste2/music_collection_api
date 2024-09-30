Rails.application.routes.draw do
  resources :users
  post 'auth/login', to: 'auth#login'
end

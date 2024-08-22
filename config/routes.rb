Rails.application.routes.draw do

  resources :videos
  post 'follows', to: 'follows#create'
  delete 'follow', to: 'follows#destroy'
  post 'likes', to: 'likes#create'
  delete 'like', to: 'likes#destroy'
  resources :profiles
  post 'signup', to: 'auth#signup', as: :auth_signup
  post 'login', to: 'auth#login', as: :auth_login
  get 'pages/index'
  root 'pages#index'
  get 'pages/protected', to: 'pages#protected'
  get 'refresh', to: 'auth#refresh'
end

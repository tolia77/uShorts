Rails.application.routes.draw do
  get 'pages/index'
  root 'pages#index'
  get 'videos/search'
  resources :videos
  post 'follows', to: 'follows#create'
  delete 'follow', to: 'follows#destroy'
  post 'likes', to: 'likes#create'
  delete 'like', to: 'likes#destroy'
  get 'profiles/search'
  resources :profiles
  post 'signup', to: 'auth#signup', as: :auth_signup
  post 'login', to: 'auth#login', as: :auth_login
  get 'pages/protected', to: 'pages#protected'
  get 'refresh', to: 'auth#refresh'
end

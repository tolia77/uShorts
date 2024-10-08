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
  resources :profiles, param: :name
  post 'signup', to: 'auth#signup', as: :auth_signup
  post 'login', to: 'auth#login', as: :auth_login
  get 'refresh', to: 'auth#refresh'
  get 'logout', to: 'auth#logout'
  get 'pages/protected', to: 'pages#protected'
end

Rails.application.routes.draw do
  resources :videos
  post 'follows', to: 'follows#create'
  delete 'follow', to: 'follows#destroy'
  resources :profiles
  post 'auth/signup'
  post 'auth/login'
  get 'pages/index'
  root 'pages#index'

end

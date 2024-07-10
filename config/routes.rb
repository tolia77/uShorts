Rails.application.routes.draw do
  post 'follows', to: 'follow#create'
  delete 'follow', to: 'follow#destroy'
  resources :profiles
  post 'auth/signup'
  post 'auth/login'
  get 'pages/index'
  root 'pages#index'

end

Rails.application.routes.draw do
  resources :profiles
  post 'auth/signup'
  post 'auth/login'
  get 'pages/index'
  root 'pages#index'

end

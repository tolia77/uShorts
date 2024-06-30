Rails.application.routes.draw do
  post 'auth/signup'
  post 'auth/login'
  get 'pages/index'
  root 'pages#index'

end

Rails.application.routes.draw do
  resources :users
  get '/login', to: 'users#login'
end

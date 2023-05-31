Rails.application.routes.draw do
  root 'articles#index'
  resources :articles
  put '/article/:id/like', to: 'articles#like', as: 'like'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

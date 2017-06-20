Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users

  resources :moves
  resources :games
  resources :users, only: [:index, :show, :destroy]

  root to: "games#index"
end

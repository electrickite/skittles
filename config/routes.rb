Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users

  resources :games do
    resources :moves, shallow: true
  end

  resources :users, only: [:index, :show]

  root to: "games#index"
end

Rails.application.routes.draw do
  resources :profiles
  devise_for :users

  resources :profiles do
    resources :games, only: [:new, :create]
  end
  resources :games, only: [:edit, :update, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get '/auth/steam/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')  
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end

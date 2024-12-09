Rails.application.routes.draw do
  resources :friends, only: [:create, :destroy]

  # Devise routes for user authentication
  devise_for :users

  # Profiles routes with nested games and search functionality
  resources :profiles do
    collection do
      get :search # /profiles/search route for searching profiles
    end

    resources :games, only: [:new, :create] # Nested routes for adding games to a profile

    # Custom routes for profile-specific actions
    post 'add_friend', on: :member # Adds a POST /profiles/:id/add_friend route

    # Wishlist routes
    member do
      get :wishlist # GET /profiles/:id/wishlist
      post :add_to_wishlist # POST /profiles/:id/wishlist/add
      delete :remove_from_wishlist # DELETE /profiles/:id/wishlist/remove
    end
  end

  # Standalone games routes for editing, updating, and destroying games
  resources :games, only: [:edit, :update, :destroy]

  # Steam authentication callback routes
  get '/auth/steam/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')

  # Health check route
  get "up", to: "rails/health#show", as: :rails_health_check

  # Root path
  root "home#index"
end

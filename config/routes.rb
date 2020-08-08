Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "sessions/new"
    get "users/new"
    get "/home", to: "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about" 
    get "/contact", to: "static_pages#contact"  
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/users/:id/following", to: "following#index", as: "following"
    get "/users/:id/followers", to: "followers#index", as: "followers"

    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index show delete)
    resources :microposts, only: [:create, :destroy]
    resources :relationships, only: [:create, :destroy]
  end
end

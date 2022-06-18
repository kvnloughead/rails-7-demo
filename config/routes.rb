Rails.application.routes.draw do
  root "static_pages#home"
  get "/help", to: "static_pages#help"        # named path: help_path
  get "/about", to: "static_pages#about"      # named path: about_path
  get "/contact", to: "static_pages#contact"  # named path: contact_path

  get "/signup", to: "users#new"              # named path: signup_path
  get "/login", to: "sessions#new"            # named path: login_path
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  
  # Provides full suite of REST routes.
  # See https://guides.rubyonrails.org/routing.html for details.
  resources :users
end

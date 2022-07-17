Rails.application.routes.draw do
  root "static_pages#home"
  get "/help", to: "static_pages#help"        # help_path
  get "/about", to: "static_pages#about"      # about_path
  get "/contact", to: "static_pages#contact"  # contact_path

  get "/signup", to: "users#new"              # signup_path
  get "/login", to: "sessions#new"            # login_path
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  
  # `resources` build-in provides full suite of REST routes.
  # See https://guides.rubyonrails.org/routing.html for details.
  resources :users
  resources :account_activations, only: [:edit] # only need edit action
end

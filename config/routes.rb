Rails.application.routes.draw do
  # Devise routes for admins
  devise_for :admins

  # Admin dashboard route
  get 'admin', to: 'admin#dashboard', as: :admin

  # Root route
  root to: 'home#index'

  # Devise routes for users using default controllers
  devise_for :users

  # Devise routes for parents with custom sessions controller
 devise_for :parents, path: 'parents', controllers: { registrations: 'parents/registrations', sessions: 'parents/sessions' }


  # Nested resources for parents and children
  resources :parents, only: [:index, :show, :edit, :update, :new, :create, :destroy] do
    member do
      get :add_child
      post :create_child
    end
    resources :children, only: [:edit, :update]
  end

  # Resource for check-ins
  resources :check_ins

  # Health check route for uptime monitors
  get "up", to: "rails/health#show", as: :rails_health_check

  # Routes for PWA functionality
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest
end


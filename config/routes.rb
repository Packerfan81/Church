Rails.application.routes.draw do
  get "admin_dashboard/show"
  # Devise routes for admins
  devise_for :admins

  # Admin dashboard route
  get 'admin_dashboard', to: 'admin_dashboard#show'

  # Root route
  root to: 'home#index'

  # Devise routes for users with custom sessions controller
  devise_for :users, controllers: { sessions: 'sessions' }

  # Nested resources for parents and children
  resources :parents do
    resources :children
  end

  # Resource for check-ins
  resources :check_ins

  # Health check route for uptime monitors
  get "up" => "rails/health#show", as: :rails_health_check

  # Routes for PWA functionality
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end

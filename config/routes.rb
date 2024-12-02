Rails.application.routes.draw do
  # Devise routes
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_for :parents, controllers: {
    sessions: 'parents/sessions',
    registrations: 'parents/registrations'
  }

  devise_for :admin, controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations'
  }

  # Parent namespace
  namespace :parents do
    get 'dashboard', to: 'dashboard#index', as: :dashboard
    delete 'destroy_account', to: 'sessions#destroy_account', as: :destroy_account
    resources :children, only: %i[index new create edit update destroy]
  end

  # Admin namespace
  namespace :admin do
    get 'dashboard', to: 'dashboard#index', as: :dashboard
    resources :children, except: [:show]
    resources :users, only: %i[index new create edit update destroy]
    resources :parents, only: %i[index new create edit update destroy]
    resources :check_outs, only: :create

  end

  # General Check-Ins/Check-Outs
  resources :check_ins, only: [:new, :create]
  resources :check_outs, only: :create
  resources :check_outs do
    get :checkout_tag, on: :member
    post '/check_out_by_qr', to: 'check_outs#check_out_by_qr'
  end

  resources :parents, only: [] do
    member do
      patch :update_preferences
    end
  end

  # Root route
  root to: 'home#index'

  # Additional pages
  get '/services', to: 'home#services', as: :services
  get '/children_ministry', to: 'children_ministry#index', as: :ministry

  # System routes
  namespace :system do
    get 'service-worker', to: 'rails/pwa#service_worker', as: :pwa_service_worker
    get 'manifest', to: 'rails/pwa#manifest', as: :pwa_manifest
    get 'up', to: 'rails/health#show', as: :rails_health_check
  end
end

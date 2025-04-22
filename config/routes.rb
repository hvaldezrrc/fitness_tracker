Rails.application.routes.draw do
  get "gyms/index"
  get "gyms/show"
  # get "workouts/show"
  # get "users/index"
  # get "users/show"
  # get "food_categories/index"
  # get "food_categories/show"
  resources :exercises, only: [ :index, :show ]
  resources :foods, only: [ :index, :show ]
  resources :food_categories, only: [ :index, :show ]
  resources :users, only: [ :index, :show ]
  resources :workouts, only: [ :show ]
  resources :gyms, only: [ :index, :show ]
  resources :workouts, only: [ :index, :show ]

  get "home", to: "static_pages#home"
  get "about", to: "static_pages#about"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "static_pages#home"
end

Rails.application.routes.draw do
  resources :transactions, except: %i[new create] do
    member do
      patch :duplicate
    end
  end

  resource :session
  namespace :api do
    namespace :v001 do
      resources :legal_entities do
        resources :missions, only: [ :create ]
      end
      resources :users do
        member do
          post :add_connection
          patch :refresh_connection
          patch :remove_connector
        end
      end
    end
  end

  get "connectors", to: "connectors#index"
  resources :users, only: [] do
    member do
      patch :update_connecting
      patch :refresh_connection
      get :connector_preview
      delete :remove_connector
      patch :update_connector
    end
  end

  resources :legal_entities
  resources :entity_users, only: [ :update ]
  resources :missions do
    resources :mission_users, only: %i[new create], shallow: true
    resources :transactions, only: %i[new create], shallow: true
    member do
      get :connectors
    end
  end

  resources :mission_users, only: %i[update destroy]

  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  # omniauth
  get "/auth/:provider/callback" => "oauth_callbacks#create"
  get "/auth/failure" => "oauth_callbacks#failure"

  # Custom logout
  match "/logout", to: "oauth_callbacks#destroy", via: :all

  # Endpoint where Xero sends live webhook events
  post "webhooks/xero", to: "xero_webhooks#receive"

  # OAuth authentication routing
  get "xero/connect", to: "xero_sessions#connect"
  get "xero/callback", to: "xero_sessions#callback"
end

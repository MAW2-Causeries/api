Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :users, only: %i[new create show] do
      collection do
        get  :register,  to: "users#new", defaults: { format: :html } # testing purpose
        post "users",  to: "users#register"
        get  :login,     to: "users#new", defaults: { format: :html } # testing purpose
        post :login,     to: "users#login"
        delete :logout,  to: "sessions#destroy"
      end
    end

    resources :sessions, only: %i[new create destroy]
  end

  resources :passwords, param: :token

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end

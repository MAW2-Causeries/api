Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :api, defaults: { format: :json } do
    devise_scope :user do
      resources :sessions, only: %i[create index]
      delete :sessions, to: "sessions#destroy", defaults: { id: nil } # obligate to separate to default id into nil
    end

    resources :users, only: %i[show update create destroy index]
    resources :guilds, only: %i[show create update destroy index]
    resources :channels, only: %i[show create update destroy index]

    match "*path", to: "base#route_not_found", via: :all
  end
  get "up" => "rails/health#show", as: :rails_health_check
end

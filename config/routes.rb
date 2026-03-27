Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :api, defaults: { format: :json } do
    scope :v1, module: :v1, as: :v1 do
      devise_scope :user do
        resources :sessions, only: %i[create index]
        delete :sessions, to: "sessions#destroy", defaults: { id: nil } # obligate to separate to default id into nil
      end

      resources :users, only: %i[show update create destroy index]
      resources :guilds, only: %i[show create update destroy index]
      resources :channels, only: %i[show create update destroy index]
      get "channels/:id/users", to: "channels#users", as: :channel_users
      get "guilds/:id/channels", to: "guilds#channels", as: :guild_channels
      get "guilds/:id/members", to: "guilds#members", as: :guild_members
      get "channels/:id/users/:user_id", to: "channels#user", as: :channel_user
      get "users/:id/channels", to: "users#channels", as: :user_channels

      match "*path", to: "base#route_not_found", via: :all
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end

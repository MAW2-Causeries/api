Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :sessions, only: %i[create index]
    delete :sessions, to: "sessions#destroy", defaults: { id: nil } # obligate to separate to default id into nil
    resources :users, only: %i[show update create destroy]
  end
  get "up" => "rails/health#show", as: :rails_health_check
end

Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"
  namespace :api do
    namespace :v1 do
      
      resources :applications, only: [:index, :show, :create, :update] do
        resources :chats, only: [:index, :show, :create, :update] do
          resources :messages, only: [:index, :show, :create]
        end
      end
    end
  end
end

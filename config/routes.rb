Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :feeds, only: [:index]

  resources :entries, only: '' do
    collection do
      get :search
    end
  end

  root 'static#index'

  namespace :api, defaults: { format: 'json' } do
    resources :search, only: '' do
      collection do
        get :entries
        get :feeds
      end
    end
    resources :tokens, only: [:create] do
      collection do
        get :current
        post :refresh
      end
    end
    resources :feeds, only: %i[index show create] do
      collection do
        get :popular
      end
      resources :entries, only: %i[index show] do
        member do
          get :tags
        end
      end
      resources :logs, only: %i[index show]
      resources :webhooks
    end
  end
end

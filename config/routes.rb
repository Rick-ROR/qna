require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  devise_for :users, controllers: {omniauth_callbacks: 'oauth'}

  namespace :user do
    get '/oauth_adding_email', to: 'emails#new'
    post '/oauth_adding_email', to: 'emails#create'
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only:%i[index show create update destroy], shallow: true
      end
    end
  end

  concern :votable do
    member do
      patch :vote
    end
  end

  concern :commentable do
    resource :comments, only: %i[create]
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true, only: %i[create update destroy] do
      member do
        patch :best
      end
    end
  end

  resources :files, only: %i[destroy]

  resources :users do
    resources :rewards, shallow: true, only: %i[index show]
  end

  resources :subscriptions, only: %i[create]
  delete '/subscriptions', to: 'subscriptions#destroy'

  get '/search', to: 'search#result'

  root to: 'questions#index'

  mount ActionCable.server => '/cable'

  authenticate :user, lambda {|user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end

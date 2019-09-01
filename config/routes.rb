Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  concern :votable do
    member do
      patch :vote
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], shallow: true, only: %i[create update destroy] do
      member do
        patch :best
      end
    end
  end

  resources :files, only: %i[destroy]

  resources :users do
    resources :rewards, shallow: true, only: %i[index show]
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end

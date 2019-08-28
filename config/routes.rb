Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions do
    member do
      patch :vote
    end
    resources :answers, shallow: true, only: %i[create update destroy] do
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
end

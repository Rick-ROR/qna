Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions do
    post 'new', as: 'new', on: :collection
    resources :answers, shallow: true, only: %i[create destroy]
  end

  root to: 'questions#index'
end

Rails.application.routes.draw do

  devise_for :users
  root to: 'pages#home'
  resources :trips do
    member do
      get :details
      patch :save
    end
    resources :steps, only: ['create', 'new', 'show']
  end
  resources :steps, only: ['index']
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

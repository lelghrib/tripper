Rails.application.routes.draw do

  get 'steps/show'
  get 'steps/index'
  devise_for :users
  root to: 'pages#home'
  resources :trips do
    member do
      get :details
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

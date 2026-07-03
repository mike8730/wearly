Rails.application.routes.draw do
  devise_for :users

  root to: "items#index"

  resources :items, only: [:index, :new, :create, :show] do
    resource :favorite, only: [:create, :destroy]
  end

  resources :favorites, only: [:index]

  resources :orders, only: [:index, :new, :create, :show] do
    collection do
      get :complete
    end
    member do
      patch :cancel
    end
  end

  post 'komoju/webhook', to: 'webhooks#komoju'

  resources :carts, only: [:index] do
    collection do
      get :checkout
    end
  end

  resources :cart_items, only: [:create, :destroy] do
    member do
      patch :increase
      patch :decrease
    end
  end
end

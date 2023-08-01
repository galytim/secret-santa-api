Rails.application.routes.draw do
  # Маршруты для Devise User (если вы используете Devise)
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Маршруты для User и Wishlist
  resources :users, only: [:show, :update, :destroy] do
    resources :wishlists, only: [:index, :show, :create, :update, :destroy]
  end
  resources :boxes do
    member do
      post 'add_participant'
      delete 'remove_participant'
    end
  end
end

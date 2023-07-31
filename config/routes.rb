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
end

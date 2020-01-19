Rails.application.routes.draw do
  resources :find_hotels, only: :index
end

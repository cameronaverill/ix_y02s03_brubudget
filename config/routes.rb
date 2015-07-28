Rails.application.routes.draw do
  get 'welcome/index'

  devise_for :users
  resources :expenditures
  root 'welcome#index'
end

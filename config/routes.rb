Rails.application.routes.draw do

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get '*permalink', to: 'structure/pages#show', format: false

end

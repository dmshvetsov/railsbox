Rails.application.routes.draw do

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'site#main'
  get '*permalink', to: 'structure/pages#show', format: false, as: 'page'

end

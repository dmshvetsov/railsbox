Rails.application.routes.draw do

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  scope '(:language)', language: /ru/ do
    root 'site#main', format: false
    get '*permalink', to: 'structure/pages#show', format: false, as: 'page'
  end

end

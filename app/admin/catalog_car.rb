module Catalog
  ActiveAdmin.register Car do

    menu parent: I18n.t('Catalog'), label: Car.model_name.human

    actions :index

    action_item :import, only: :index do
      link_to I18n.t('activeadmin.import'), action: :import
    end

    collection_action :import, method: :get do
      render template: 'admin/catalog/cars/import'
    end

    collection_action :import, method: :post do
      flash[:notice] = 'ok'
      redirect_to action: :index
    end

  end
end

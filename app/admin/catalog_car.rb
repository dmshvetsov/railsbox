module Catalog
  ActiveAdmin.register Car do

    menu parent: I18n.t('Catalog'), label: Car.model_name.human

    actions :index

    action_item :import_form, only: :index do
      link_to I18n.t('activeadmin.import'), import_form_admin_catalog_cars_path
    end

    collection_action :import_form, method: :get do
      render template: 'admin/catalog/cars/import'
    end

    collection_action :import, method: :post do
      file = params.fetch(:car_data, {}).fetch(:csv_file, nil)

      if file
        importer = ::FasareImporter.new file.path, Catalog::Car
        importer.import
        flash[:notice] = 'Import completed'
      else
        flash[:alert] = 'No file provided'
      end

      redirect_to action: :index
    end

  end
end

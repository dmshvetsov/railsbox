module Catalog
  ActiveAdmin.register Car do

    menu parent: I18n.t('Catalog'), label: Car.model_name.human

    actions :index

  end
end

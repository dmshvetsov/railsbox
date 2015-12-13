ActiveAdmin.register Structure::Page do

  sortable

  config.clear_action_items!
  config.filters = false
  config.sort_order = 'position_asc'

  breadcrumb do
    nil
  end

  permit_params do
    permited = [
      :title,
      :slug,
      :parent_id,
      :visible,
      :published_at,
      :language,
      :content_type,
      :menu
    ]
    if content_class = params.fetch(:structure_page, {}).fetch(:content_type, nil)
      content_params = content_class.constantize.attribute_names
      permited << { content_attributes: content_params }
    else
      permited
    end
  end

  # Main language
  scope(Rails.configuration.i18n.default_locale.to_s.downcase, default: true) do |relation|
    relation.where(language: Rails.configuration.i18n.default_locale.to_s.downcase)
  end
  # Additional languages
  %w(ru).each do |lang|
    scope(lang) do |relation|
      relation.where(language: lang)
    end
  end

  index as: :tree

  action_item 'AddContentDropDown', only: :index do
    dropdown_menu "Add Page" do
      Structure.content_types.each do |content_type|
        item(content_type.constantize.model_name.human,
                new_admin_structure_page_path(
                  parent_id: params[:categorizer_current_id],
                  content_type: content_type,
                  language: params[:scope],
                  menu: params[:menu]))
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs f.object.model_name.human do
      f.input :parent, collection: Structure::Page.where(language: I18n.locale).where.not(id: f.object.id)
      f.input :title
      f.input :slug
      f.input :visible
      f.input :published_at
      f.input :content_type, as: :hidden
      f.input :language, as: :hidden
      f.input :menu, as: :hidden
    end
    f.inputs f.object.content.model_name.human, for: :content, &"#{f.object.content.class.name}::Admin".constantize.fields
    f.actions do
      f.action :submit, as: :input
      f.cancel_link(admin_structure_pages_path(categorizer_current_id: f.object.id || params[:parent_id], menu: params[:menu]))
    end
  end

  # Controller and Actions
  controller do
    before_action :set_locale

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def index
      params[:menu] ||= 'MainMenu'
      index!
    end

    def new
      new! do
        @structure_page.menu = params[:menu]
        @structure_page.language = params.fetch(:language, Rails.configuration.i18n.default_locale)
        @structure_page.parent_id = params[:parent_id] if params[:parent_id]
        @structure_page.content = params[:content_type].constantize.new if params[:content_type]
      end
    end

    def create
      @structure_page = Structure::PageCreator.for(end_of_association_chain, *resource_params).create

      create! do |success, failure|
        success.html { redirect_to admin_structure_pages_path(categorizer_current_id: resource.id, menu: resource.menu, scope: resource.language) }
      end
    end

    def update
      @structure_page = Structure::PageUpdater.for(resource).update(*resource_params)

      update! do |success, failure|
        success.html { redirect_to admin_structure_pages_path(categorizer_current_id: resource.id, menu: resource.menu, scope: resource.language) }
      end
    end

    def destroy
      destroy! do |format|
        format.html { redirect_to admin_structure_pages_path(categorizer_current_id: resource.parent_id, menu: resource.menu, scope: resource.language) }
      end
    end

    def set_locale
      locale = params[:scope] || params[:language] || Rails.configuration.i18n.default_locale
      I18n.locale = locale
    end
  end

  member_action :hide, method: :put do
    resource.update(visible: false)
    redirect_to admin_structure_pages_path(categorizer_current_id: resource.id, menu: resource.menu)
  end

  member_action :reveal, method: :put do
    resource.update(visible: true)
    redirect_to admin_structure_pages_path(categorizer_current_id: resource.id, menu: resource.menu)
  end

  # Batch Actions
  destroy_batch_action_options = {
    priority: 100,
    confirm: proc{ I18n.t('active_admin.batch_actions.delete_confirmation', plural_model: active_admin_config.plural_resource_label.downcase) },
    if: proc{ controller.action_methods.include?('destroy') && authorized?(ActiveAdmin::Auth::DESTROY, active_admin_config.resource_class) }
  }
  batch_action :destroy, destroy_batch_action_options do |selected_ids|
    batch_action_collection.find(selected_ids).each do |record|
      authorize! ActiveAdmin::Auth::DESTROY, record
      destroy_resource(record)
    end

    redirect_to(collection_path(params),
                notice: I18n.t("active_admin.batch_actions.succesfully_destroyed",
                               count: selected_ids.count,
                               model: active_admin_config.resource_label.downcase,
                               plural_model: active_admin_config.plural_resource_label(count: selected_ids.count).downcase))
  end

end

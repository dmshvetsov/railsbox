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

  # Content create buttons
  Structure.content_models.each do |model_string|
    action_item model_string, only: :index do
      link_to "Create #{model_string.constantize.model_name.human}",
        new_admin_structure_page_path(
          parent_id: params[:categorizer_current_id],
          content_type: model_string,
          language: params[:scope],
          menu: params[:menu])
    end
  end

  # Section create buttons
  Structure.section_models.each do |model_string|
    action_item model_string, only: :index do
      link_to "Create #{model_string.constantize.model_name.human}",
        new_admin_structure_page_path(
          parent_id: params[:categorizer_current_id],
          content_type: model_string,
          language: params[:scope],
          menu: params[:menu])
    end
  end

  index as: :tree

  form do |f|
    f.semantic_errors
    f.inputs f.object.model_name.human do
      f.input :parent
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
        success.html { redirect_to admin_structure_pages_path(categorizer_current_id: resource.id), menu: resource.menu }
      end
    end

    def update
      @structure_page = Structure::PageUpdater.for(resource).update(*resource_params)

      update! do |success, failure|
        success.html { redirect_to admin_structure_pages_path(categorizer_current_id: resource.id, menu: resource.menu) }
      end
    end

    def destroy
      destroy! do |format|
        format.html { redirect_to admin_structure_pages_path(categorizer_current_id: resource.parent_id), menu: resource.menu }
      end
    end

    def set_locale
      locale = params[:scope] || params[:language] || Rails.configuration.i18n.default_locale
      I18n.locale = locale
    end
  end

end
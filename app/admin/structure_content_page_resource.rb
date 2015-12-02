ActiveAdmin.register Structure::ContentPage do

  menu false
  actions :all, except: [:index, :show]
  config.sort_order = 'position_asc'
  sortable

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
      :type,
      :content_type,
      :menu
    ]
    if content_class = params.fetch(:structure_content_page, {}).fetch(:content_type, nil)
      content_params = content_class.constantize.attribute_names
      permited << { content_attributes: content_params }
    else
      permited
    end
  end

  action_item :view, only: :edit do
    language = resource.language == 'en' ? nil : resource.language
    link_to 'View on site', page_path(resource.permalink, language: language) if resource.published?
  end

  form do |f|
    f.semantic_errors
    f.inputs f.object.model_name.human do
      f.input :parent
      f.input :title
      f.input :slug
      f.input :visible
      f.input :published_at
      f.input :language, as: :hidden
      f.input :content_type, as: :hidden
      f.input :menu, as: :hidden
    end
    f.inputs f.object.content.class.model_name.human, for: :content, &"#{f.object.content.class.name}::Admin".constantize.fields
    f.actions do
      f.action :submit
      f.cancel_link(admin_structure_section_pages_path(categorizer_current_id: (f.object.parent_id || params[:parent_id]), menu: params[:menu]))
    end
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def new
      new! do
        @structure_content_page.menu = params[:menu]
        @structure_content_page.language = params.fetch(:language, Rails.configuration.i18n.default_locale)
        @structure_content_page.parent_id = params[:parent_id] if params[:parent_id]
        @structure_content_page.content = params[:content_type].constantize.new if params[:content_type]
      end
    end

    def create
      @structure_content_page = Structure::PageCreator.for(end_of_association_chain, *resource_params).create

      create! do |success, failure|
        success.html { redirect_to admin_structure_section_pages_path(categorizer_current_id: resource.parent_id, menu: resource.menu) }
      end
    end

    def update
      @structure_content_page = Structure::PageUpdater.for(resource).update(*resource_params)

      update! do |success, failure|
        success.html { redirect_to admin_structure_section_pages_path(categorizer_current_id: resource.parent_id, menu: resource.menu) }
      end
    end

    def destroy
      destroy! do |format|
        format.html { redirect_to admin_structure_section_pages_path(categorizer_current_id: resource.parent_id, menu: resource.menu) }
      end
    end
  end

end

ActiveAdmin.register Structure::ContentPage do

  menu false
  actions :all, except: [:index, :show]
  config.sort_order = 'position_asc'
  sortable

  permit_params do
    permited = [
      :title,
      :slug,
      :parent_id,
      :visible,
      :published_at,
      :language,
      :type,
      :content_type
    ]
    if content_class = params.fetch(:structure_content_page, {}).fetch(:content_type, nil)
      # TODO: unsafe permited params
      content_params = content_class.constantize.attribute_names
      permited << { content_attributes: content_params }
    else
      permited
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs f.object.model_name.human do
      f.input :parent
      f.input :title
      f.input :slug
      f.input :language
      f.input :visible
      f.input :published_at
      f.input :content_type, as: :hidden
    end
    f.inputs f.object.content.class.model_name.human, for: :content do |content|
      content.inputs
    end
    f.actions do
      f.action :submit, as: :input
      f.action :cancel, as: :link, url: admin_structure_section_pages_path(categorizer_current_id: f.object.parent_id || params[:parent_id]), wrapper_html: { class: 'cancel' }
    end
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def new
      new! do
        @structure_content_page.parent_id = params[:parent_id] if params[:parent_id]
        @structure_content_page.content = params[:content_type].constantize.new if params[:content_type]
      end
    end

    def create
      @structure_content_page = Structure::PageCreator.for(end_of_association_chain, *resource_params).create

      create! do |success, failure|
        success.html { redirect_to admin_structure_section_pages_path(categorizer_current_id: resource.parent_id) }
      end
    end

    def update
      @structure_content_page = Structure::PageUpdater.for(resource).update(*resource_params)

      update! do |success, failure|
        success.html { redirect_to admin_structure_section_pages_path(categorizer_current_id: resource.parent_id) }
      end
    end

    def destroy
      destroy! do |format|
        format.html { redirect_to admin_structure_section_pages_path(categorizer_current_id: resource.parent_id) }
      end
    end
  end

end

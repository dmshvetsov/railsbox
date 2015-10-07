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
    f.inputs do
      f.input :parent
      f.input :title
      f.input :slug
      f.input :language
      f.input :visible
      f.input :published_at
      f.input :content_type, as: :hidden
    end
    f.inputs for: :content do |content|
      content.inputs
    end
    f.actions do
      f.action :submit, as: :input
      f.action :cancel, as: :link, url: admin_structure_section_pages_path(categorizer_current_id: f.object.parent_id || params[:parent_id]), wrapper_html: { class: 'cancel' }
    end
  end

  controller do
    def new
      super do
        @structure_content_page.parent_id = params[:parent_id] if params[:parent_id]
        @structure_content_page.content = params[:content_type].constantize.new if params[:content_type]
      end
    end

    def create
      super do |success, failure|
        success.html { redirect_to admin_structure_section_pages_path(categorizer_current_id: resource.parent_id) }
      end
    end

    def update
      super do |success, failure|
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

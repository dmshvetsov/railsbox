ActiveAdmin.register Structure::SectionPage do

  menu label: 'Site Structure'

  permit_params :title,
    :slug,
    :parent_id,
    :visible,
    :published_at,
    :language,
    :type

  config.clear_action_items!
  config.filters = false
  config.sort_order = 'position_asc'
  sortable

  index as: :tree_with_childs, content: :content_page

  action_item 'Create Content', only: :index, if: proc { params[:categorizer_current_id].present? } do
    link_to 'Create Content Page', new_admin_structure_content_page_path(parent_id: params[:categorizer_current_id])
  end

  action_item 'Create Section', only: :index do
    link_to 'Create Section Page', new_admin_structure_section_page_path(parent_id: params[:categorizer_current_id])
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
    end
    f.actions do
      f.action :submit, as: :input
      f.action :cancel, as: :link, url: admin_structure_section_pages_path(categorizer_current_id: f.object.parent_id || params[:parent_id]), wrapper_html: { class: 'cancel' }
    end
  end

  controller do
    def new
      super do
        @structure_section_page.parent_id = params[:parent_id] if params[:parent_id]
      end
    end

    def create
      super do |success, failure|
        success.html { redirect_to admin_structure_section_pages_path(categorizer_current_id: resource.id) }
      end
    end

    def update
      super do |success, failure|
        success.html { redirect_to admin_structure_section_pages_path(categorizer_current_id: resource.id) }
      end
    end

    def destroy
      destroy! do |format|
        format.html { redirect_to admin_structure_section_pages_path(categorizer_current_id: resource.parent_id) }
      end
    end
  end

end

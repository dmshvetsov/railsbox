ActiveAdmin.register Structure::ContentPage do

  menu false
  actions :all, except: [:index, :show]

  permit_params :title,
    :slug,
    :parent_id,
    :visible,
    :published_at,
    :language,
    :type

  form do |f|
    f.semantic_errors
    f.inputs do
      if params[:parent_id]
        f.input :parent_id, as: :hidden, input_html: { value: params[:parent_id] }
      else
        f.input :parent
      end
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

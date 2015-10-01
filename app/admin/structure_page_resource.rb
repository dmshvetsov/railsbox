ActiveAdmin.register Structure::Page do

  config.clear_action_items!
  config.filters = false
  config.sort_order = 'position_asc' # assumes you are using 'position' for your acts_as_list column
  sortable # creates the controller action which handles the sorting

  index as: :tree_with_childs, childs_type: 'Structure::SectionPage', content: :content_page

  action_item 'Create content', only: :index, if: proc { params[:categorizer_current_id].present? } do
    link_to 'Create content', new_admin_structure_content_page_path(parent_id: params[:categorizer_current_id])
  end

  action_item 'Create section', only: :index do
    link_to 'Create section', new_admin_structure_page_path(parent_id: params[:categorizer_current_id], type: 'Structure::SectionPage')
  end

end

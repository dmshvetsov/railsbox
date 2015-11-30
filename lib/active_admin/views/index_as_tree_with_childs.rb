module ActiveAdmin
  module Views
    class IndexAsTreeWithChilds < ActiveAdmin::Component

      def build(page_presenter, collection)
        @collection = collection
        @page_presenter = page_presenter

        categorizer_current_id = params['categorizer_current_id']

        resource_name = active_admin_config.resource_name
        language = params.fetch(:scope, Rails.configuration.i18n.default_locale)
        @categorizer = Categorizer.new(resource_name.singular, resource_name.name, categorizer_current_id, params[:menu], language, collection)

        panel 'Sections', class: 'table-with-tree__categorizer' do
          build_tree @categorizer.tree
        end

        div class: 'table-with-tree__collection' do
          build_current_category_panel if categorizer_current_id
          build_childs_table(categorizer_current_id)
          build_content_table(categorizer_current_id) if @page_presenter[:content]
        end

        div class: 'table-with-tree__clearfix'
      end

      def build_tree tree
        ul do
          tree.each do |item, childs|
            # TODO: do not pass childs to categorizer like a chain
            build_item item, childs
            build_tree childs if @categorizer.in_current_path?(item.id)
          end
        end
      end

      def build_item item, childs
        title = @categorizer.title_for(item, childs)
        url = url_for("categorizer_current_id" => item.id, "menu" => item.menu, "scope" => params[:scope])
        css_class = @categorizer.css_class_for(item)

        li do
          link_to title, url, class: css_class
        end
      end

      def build_current_category_panel
        current_category = @categorizer.current_category

        panel current_category.title do
          div (current_category.visible) ? 'visible' : 'hidden'
          div do
            route = ['page', 'path'].join('_')
            language = current_category.language == 'en' ? nil : current_category.language
            link_to 'View on site', send(route, current_category.permalink, language: language)
          end
          div do
            route = ['edit', 'admin', current_category.model_name.singular_route_key, 'path'].join('_')
            link_to 'Edit section', send(route, current_category)
          end
          div do
            route = ['admin', current_category.model_name.singular_route_key, 'path'].join('_')
            link_to 'Delete section', send(route, current_category), method: :delete
          end
        end
      end

      def build_childs_table(categorizer_current_id)
        sql = { parent_id: categorizer_current_id, menu: params[:menu] }
        childs_categories = @collection.where sql

        childs_categories_presenter = ActiveAdmin::PagePresenter.new as: :table do
          selectable_column
          column :title
          column :visible
          sortable_handle_column
          actions
        end

        h2 'Sub sections'
        insert_tag(IndexAsTable, childs_categories_presenter, childs_categories)
      end

      def build_content_table(categorizer_current_id)
        if @categorizer.current_category
          content = @categorizer.current_category.send(@page_presenter[:content].to_s.demodulize.underscore.pluralize).where(menu: params[:menu])
        else
          content = @page_presenter[:content].to_s.constantize.where(menu: params[:menu]).roots
        end

        content_presenter = ActiveAdmin::PagePresenter.new as: :table do
          selectable_column
          column :title
          column :visible
          # Method from the activeadmin-sortable gem
          # ActiveAdmin::Sortable::ControllerActions::TableMethods::sortable_handle_column
          # TODO: abandon activeadmin-sortable in the future
          column '', :class => "activeadmin-sortable" do |resource|
            route = ['admin', resource.model_name.singular_route_key, 'path'].join('_')
            sort_url, query_params = send(route, resource).split '?', 2
            sort_url += "/sort"
            sort_url += "?" + query_params if query_params
            content_tag :span, '&#x2195;'.html_safe, :class => 'handle', 'data-sort-url' => sort_url
          end
          actions defaults: false do |row|
            item I18n.t('active_admin.edit'), edit_admin_structure_content_page_path(row, parent_id: params[:categorizer_current_id]), class: 'edit_link member_link'
            item I18n.t('active_admin.delete'), admin_structure_content_page_path(row), class: 'delete_link member_link', method: :delete
          end
        end

        h2 'Section content'
        insert_tag(IndexAsTable, content_presenter, content)
      end

      class << self

        def index_name
          'tree_with_childs'
        end

      end
    end

  end
end

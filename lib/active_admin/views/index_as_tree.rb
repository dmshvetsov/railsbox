module ActiveAdmin
  module Views
    class IndexAsTree < ActiveAdmin::Component

      def build(page_presenter, collection)
        @collection = collection
        @page_presenter = page_presenter

        categorizer_current_id = params['categorizer_current_id']

        resource_name = active_admin_config.resource_name
        @language = params.fetch(:scope, Rails.configuration.i18n.default_locale)
        @categorizer = CategorizerTree.new(resource_name.singular, resource_name.name, categorizer_current_id, params[:menu], @language, collection)

        panel 'Sections', class: 'table-with-tree__categorizer' do
          build_tree(@categorizer.tree)
        end

        div class: 'table-with-tree__collection' do
          build_current_category_panel if categorizer_current_id
          build_childs_table(categorizer_current_id)
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
            link_to 'Edit Page', send(route, current_category)
          end
          div do
            route = ['admin', current_category.model_name.singular_route_key, 'path'].join('_')
            link_to 'Delete Page', send(route, current_category), method: :delete
          end
        end
      end

      def build_childs_table(categorizer_current_id)
        sql = { parent_id: categorizer_current_id, menu: params[:menu], language: @language }
        childs_categories = @collection.where sql

        child_pages_presenter = ActiveAdmin::PagePresenter.new as: :table do
          selectable_column
          column :title
          column :type do |row|
            row.content_type
          end
          column :visible
          sortable_handle_column
          actions
        end

        h2 'Sub Pages'
        insert_tag(IndexAsTable, child_pages_presenter, childs_categories)
      end

      class << self

        def index_name
          'tree'
        end

      end
    end

  end
end

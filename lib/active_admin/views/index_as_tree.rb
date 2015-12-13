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

        panel 'Pages Tree', class: 'table-with-tree__categorizer' do
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
        language = current_category.language == 'en' ? nil : current_category.language

        panel 'Page' do
          attributes_table_for(current_category, :title, :permalink, :published_at, :visible, :content_type)
          table_actions do
            route = ['page', 'path'].join('_')
            text_node link_to('View Page on Site', send(route, current_category.permalink, language: language), class: 'member_link')
            text_node link_to('Edit Page', url_for(['edit', 'admin', current_category, { menu: params[:menu], language: language }]), class: 'member_link')
            if current_category.visible
              text_node link_to('Hide Page', hide_admin_structure_page_path(current_category, { categorizer_current_id: current_category.id, menu: current_category.menu }), class: 'member_link', method: :put)
            else
              text_node link_to('Show Page', reveal_admin_structure_page_path(current_category, { categorizer_current_id: current_category.id, menu: current_category.menu }), class: 'member_link', method: :put)
            end
            route = ['admin', current_category.model_name.singular_route_key, 'path'].join('_')
            text_node link_to 'Delete Page', send(route, current_category), class: 'member_link', method: :delete, data: { confirm: I18n.t('active_admin.delete_confirmation') }
          end
        end
      end

      def build_childs_table(categorizer_current_id)
        sql = { parent_id: categorizer_current_id, menu: params[:menu], language: @language }
        childs_categories = @collection.where sql

        return h2('No Child Pages') unless childs_categories.any?

        child_pages_presenter = ActiveAdmin::PagePresenter.new as: :table, row_class: -> elem { 'hidden' unless elem.visible? } do
          selectable_column
          column :title
          column :content_type
          column :visible
          sortable_handle_column
          actions
        end

        input name: :categorizer_current_id, type: :hidden, value: params[:categorizer_current_id]
        input name: :menu, type: :hidden, value: params[:menu]

        h2 'Child Pages'
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

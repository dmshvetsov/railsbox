module Structure
  module Menu
    class Base

      attr_reader :items, :params

      # options:
      #   expand_all: load all menu items although which menu item is active
      #   limit_depth: level of deep of menu (for more information ClosureTree gem #hash_tree)
      DEFAULT_OPTIONS = {
        expand_all: false,
        limit_depth: nil
      }

      def initialize(controller_parameters, menu_options)
        @params = controller_parameters
        @options = menu_options.reverse_merge(DEFAULT_OPTIONS)
        @items = nil
      end

      def self.build(controller_parameters, menu_options)
        instance = new(controller_parameters, menu_options)
        instance.build_menu_items_tree(instance.pages.hash_tree(limit_depth: menu_options[:limit_depth]))
        instance
      end

      def self.in_categorizer?
        true
      end

      def pages
        Structure::Page.items(menu: self.class.name, language: @params[:language])
      end

      def to_partial_path
        "structure/menus/#{self.class.name.demodulize.underscore}"
      end

      def item_class
        "#{self.class.name}Item".constantize
      end

      def build_menu_items_tree(pages)
        result = []
        pages.each do |page, childs|
          next unless page.public?
          children = (@options[:expand_all] || in_current_path?(page)) ? self.build_menu_items_tree(childs) : []
          result << build_menu_item(page, children)
        end

        @items = result
      end

      protected

      def build_menu_item(page, children)
        options = {}
        options[:active] = true if path == page.permalink
        options[:in_path] = true if in_current_path?(page)

        item_class.new(page, children, options)
      end

      private

      # Menu item page in ancestors path or currently active?
      def in_current_path?(page)
        !!path.match("^#{page.permalink}")
      end

      # Current path (requested permalink)
      def path
        @params.fetch(:permalink, '/')
      end

    end
  end
end

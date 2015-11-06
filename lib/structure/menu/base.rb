module Structure
  module Menu
    class Base

      attr_reader :items, :params

      DEFAULT_OPTIONS = {
        expand_all: false,
        limit_depth: nil
      }

      # options:
      #   expand_all: load all menu items although which menu item is active
      #   limit_depth: level of deep of menu (for more information ClosureTree gem #hash_tree)
      def initialize(controller_parameters, menu_options)
        @params = controller_parameters
        @options = menu_options.reverse_merge(DEFAULT_OPTIONS)
        @items = build_menu_items_tree(Structure::Page.hash_tree(limit_depth: @options[:limit_depth]))
      end

      def to_partial_path
        "structure/menus/#{self.class.name.demodulize.underscore}"
      end

      def item_class
        "#{self.class.name}Item".constantize
      end

      protected

      def build_menu_items_tree(pages)
        result = []
        pages.each do |page, childs|
          next unless page.public?
          children = (@options[:expand_all] || in_current_path?(page)) ? self.build_menu_items_tree(childs) : []
          result << build_menu_item(page, children)
        end

        result
      end

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

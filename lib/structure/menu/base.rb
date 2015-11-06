module Structure
  module Menu
    class Base

      attr_reader :items, :params

      def initialize(controller_parameters)
        @params = controller_parameters
        @items = build_menu_items_tree(Structure::Page.hash_tree)
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
          children = self.build_menu_items_tree(childs)
          result << build_menu_item(page, children)
        end

        result
      end

      def build_menu_item(page, children)
        options = {}
        options.tap do |o|
          o[:active] = true if @params['permalink'] == page.permalink
        end
        item_class.new(page, children, options)
      end

    end
  end
end

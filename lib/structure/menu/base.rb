module Structure
  module Menu
    class Base

      attr_reader :items

      def initialize(items)
        @items = items
      end

      def self.tree
        new(self.build_menu_items_tree(Structure::Page.hash_tree))
      end

      def to_partial_path
        "structure/menus/#{self.class.name.demodulize.underscore}"
      end

      def self.item_class
        "#{self.name}Item".constantize
      end

      private

      def self.build_menu_items_tree(pages)
        result = []
        pages.each do |page, childs|
          children = self.build_menu_items_tree(childs)
          result << item_class.new(page, children)
        end

        result
      end

    end
  end
end

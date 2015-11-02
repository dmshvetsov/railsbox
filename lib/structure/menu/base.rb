module Structure
  module Menu
    class Base

      attr_reader :item

      def initialize(item)
        @item = item
      end

      def self.tree
        self.build_hash_tree(Structure::Page.hash_tree)
      end

      def to_partial_path
        "structure/menus/#{self.class.name.demodulize.underscore}"
      end

      private

      def self.build_hash_tree(pages)
        result = {}
        pages.each do |page, childs|
          menu_item = new(page)
          result[menu_item] = self.build_hash_tree(childs)
        end

        result
      end

    end
  end
end

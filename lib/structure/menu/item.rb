module Structure
  module Menu
    class Item

      include ActiveModel::Conversion

      attr_reader :page, :children

      def initialize(page, children)
        @page = page
        @children = children
      end

      def to_partial_path
        "structure/menus/#{self.class.name.demodulize.underscore}"
      end

    end
  end
end

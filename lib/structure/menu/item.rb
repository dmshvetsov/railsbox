module Structure
  module Menu
    class Item

      include ActiveModel::Conversion

      attr_reader :page, :children

      def initialize(page, children, options)
        @page = page
        @children = children
        @active = options[:active]
      end

      def to_partial_path
        "structure/menus/#{self.class.name.demodulize.underscore}"
      end

      def active?
        @active
      end

    end
  end
end

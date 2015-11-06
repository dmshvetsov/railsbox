module Structure
  module Menu
    class Item

      include ActiveModel::Conversion

      attr_reader :page, :children

      def initialize(page, children, options)
        @page = page
        @children = children
        @active = options[:active]
        @in_path = options[:in_path]
      end

      def to_partial_path
        "structure/menus/#{self.class.name.demodulize.underscore}"
      end

      # Menu item page is currently active?
      def active?
        @active
      end

      # Menu item page in ancestors path or currently active?
      def in_path?
        @in_path
      end

    end
  end
end

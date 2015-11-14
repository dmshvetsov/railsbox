module Structure
  module Breadcrumbs
    class Item

      attr_reader :page

      def initialize(page)
        @page = page
      end

      def to_partial_path
        'structure/breadcrumbs/item'
      end

    end
  end
end

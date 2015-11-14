module Structure
  module Breadcrumbs
    class Base

      attr_reader :items, :current_page

      def initialize(current_page)
        @current_page = current_page
        @items = build_crumbs
      end

      def to_partial_path
        'structure/breadcrumbs/breadcrumbs'
      end

      protected

      def build_crumbs
        ancestors = @current_page.ancestors.to_a
        crumbs = ancestors.map { |page| Item.new(page) }
        crumbs.unshift(build_main_item) if @current_page.persisted?
        crumbs
      end

      def build_main_item
        Item.new(Structure.root_page)
      end

    end
  end
end

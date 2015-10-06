module ActiveAdmin
  module Views
    # Categorizer
    #
    # Assume that tree elements of a categorizer menu
    # respond to title and id
    class Categorizer

      # Id for virtual not persistent root category
      ROOT_CATEGORY_ID = nil

      attr_reader :name, :current_category, :model

      def initialize(name, model, current_id, associated_collection)
        @name = name
        @model = model.constantize
        @current_id = current_id.to_i if current_id
        @associated_collection = associated_collection
        @current_category_ancestors_path = [ROOT_CATEGORY_ID]

        if @current_id
          @current_category = @model.find(@current_id)
          @current_category_ancestors_path.concat @current_category.self_and_ancestors_ids
        end
      end

      # Tree
      # hash of key-category => value-childrens
      def tree
        { @model.new(id: ROOT_CATEGORY_ID, title: 'Root') => @model.hash_tree }
      end

      # Associated collection for current category
      def current_associated_collection
        @associated_collection.where("#{@name}_id" => @current_id)
      end

      # Current categorizer id is in ancestors paht?
      def in_current_path?(category_id)
        @current_category_ancestors_path.include? category_id
      end

      def current? category_id
        @current_id == category_id.to_i
      end

      def title_for category, childs
        prefix = ''

        if childs && childs.any?
          prefix = in_current_path?(category.id) ? '-' : '+'
          prefix << ' '
        end

        prefix + category.title
      end

      def css_class_for category
        css_class = []
        css_class << 'active' if category.id == @current_id
        css_class << 'unpublished' unless category.visible
        css_class.empty? ? nil : css_class.join(' ')
      end

    end

  end
end

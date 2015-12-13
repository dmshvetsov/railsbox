module Structure
  class SectionPageCellConcept < Cell::Concept

    abstract!

    include ActionView::Helpers::UrlHelper

    # All pages always have this fields
    property :title
    property :published_at
    property :content

    # Item for list view
    def item
      render(:item)
    end

    # Render children pages of sections
    def children
      collection = model.children
      concept(self.class.name, collection: collection, method: :item)
    end

    def permalink
      "/#{model.permalink}"
    end

  end
end

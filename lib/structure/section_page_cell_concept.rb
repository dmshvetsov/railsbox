module Structure
  class SectionPageCellConcept < Cell::Concept

    abstract!

    include ActionView::Helpers::UrlHelper

    # All pages always have this fields
    property :title
    property :permalink
    property :published_at
    property :content

    # Item for list view
    def item
      render(:item)
    end

    # Render children pages of sections
    def children
      collection = model.children.where(type: 'Structure::SectionPage')
      concept(self.class.name, collection: collection, method: :item)
    end

  end
end

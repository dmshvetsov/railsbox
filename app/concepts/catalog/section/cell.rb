class Catalog::Section::Cell < Cell::Concept

  include ActionView::Helpers::UrlHelper

  property :title

  def show
    render
  end

  def anons
    render(:anons)
  end

  private

  def page
    @options[:page]
  end

  def children
    if page
      ids = page.children.where(type: 'Structure::SectionPage').map(&:content_id)
      collection = Catalog::Section.where(id: ids)
      list = concept('catalog/section/cell', collection: collection, method: :anons)
      "<ul>#{list}</ul>"
    end
  end

  def description
    model.description || 'No description'
  end

end

class Catalog::Section::Cell < Cell::Concept

  include ActionView::Helpers::UrlHelper

  property :content
  property :title

  def show
    render
  end

  def anons
    render(:anons)
  end

  private

  def children
    ids = model.children.where(type: 'Structure::SectionPage').map(&:content_id)
    collection = Catalog::Section.where(id: ids)
    list = concept('catalog/section/cell', collection: collection, method: :anons)
    "<ul>#{list}</ul>"
  end

  def description
    content.description || 'No description'
  end

end

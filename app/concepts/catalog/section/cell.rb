class Catalog::Section::Cell < Structure::PageViewModel

  def show
    render
  end

  def item
    render(:item)
  end

  private

  def description
    content.description || 'No description'
  end

end

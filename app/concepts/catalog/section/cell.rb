class Catalog::Section::Cell < Structure::SectionPageCellConcept

  def show
    render
  end

  private

  def description
    content.description || 'No description'
  end

end

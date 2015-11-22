class Catalog::Section::Cell < Cell::Concept

  def show
    render
  end

  private

  def description
    model.description || 'No description'
  end

end

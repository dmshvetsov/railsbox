class Catalog::Section::Cell::Show < Trailblazer::Cell

  def show
    render
  end

  private

  def description
    content.description || 'No description'
  end

end

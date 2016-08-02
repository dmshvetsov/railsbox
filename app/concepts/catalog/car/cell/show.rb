class Catalog::Car::Cell::Show < Trailblazer::Cell

  property :content

  def show
    render
  end

  private

  def _model
    content.model
  end

  def year
    content.year
  end

  def make
    content.make
  end

end

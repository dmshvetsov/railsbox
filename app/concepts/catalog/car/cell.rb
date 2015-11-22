class Catalog::Car::Cell < Cell::Concept

  property :year
  property :make

  def show
    render
  end

  private

  def _model
    model.model
  end
end

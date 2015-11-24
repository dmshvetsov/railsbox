class BasicSection::Cell < Cell::Concept

  property :content

  def show
    render
  end

  private

  def description
    content.description
  end

end

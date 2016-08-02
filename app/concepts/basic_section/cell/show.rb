class BasicSection::Cell::Show < Trailblazer::Cell

  property :content

  def show
    render
  end

  private

  def description
    content.description
  end

end

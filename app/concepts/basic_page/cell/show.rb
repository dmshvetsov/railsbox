class BasicPage::Cell::Show < Trailblazer::Cell

  property :content

  def show
    render
  end

  private

  def body
    content.body
  end

end

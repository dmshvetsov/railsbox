class BasicPage::Cell < Cell::Concept

  property :content

  def show
    render
  end

  private

  def body
    content.body
  end

end

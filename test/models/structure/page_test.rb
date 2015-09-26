require "test_helper"

class Structure::PageTest < ActiveSupport::TestCase
  def page
    @page ||= Structure::Page.new
  end

  def test_valid
    assert page.valid?
  end
end

require "test_helper"

class TextPageTest < ActiveSupport::TestCase
  def text_page
    @text_page ||= TextPage.new
  end

  def test_valid
    assert text_page.valid?
  end
end

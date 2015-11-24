require 'test_helper'

class BasicSectionConceptTest < Cell::TestCase

  test 'show' do
    basic_section = BasicSection.new(description: '<p>this is a basic page</p>')
    page = Structure::Page.new(title: 'Basic Section', content: basic_section)
    html = concept('basic_section/cell', page).call(:show)
    assert_match '<p>this is a basic page</p>', html.to_s
  end

end

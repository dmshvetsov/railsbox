require 'test_helper'

class BasicPageConceptTest < Cell::TestCase

  test 'show' do
    basic_page = BasicPage.new(body: '<p>this is a basic page</p>')
    html = concept('basic_page/cell', basic_page).(:show)
    assert_match '<p>this is a basic page</p>', html.to_s
  end

end

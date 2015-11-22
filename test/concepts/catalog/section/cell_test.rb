require 'test_helper'

class Catalog::SectionConceptTest < Cell::TestCase

  test 'show' do
    catalog_section = Catalog::Section.new(description: '<p>this is description</p>')
    html = concept('catalog/section/cell', catalog_section).call(:show)
    assert_match '<p>this is description</p>', html.to_s
  end

end

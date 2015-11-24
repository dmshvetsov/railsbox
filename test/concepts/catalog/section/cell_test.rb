require 'test_helper'

class Catalog::SectionConceptTest < Cell::TestCase

  test 'show' do
    catalog_section = Catalog::Section.new(description: '<p>this is description</p>')
    page = Structure::Page.new(title: 'Catalog Section', content: catalog_section)
    html = concept('catalog/section/cell', page).call(:show)
    assert_match '<p>this is description</p>', html.to_s
  end

end

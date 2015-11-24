require 'test_helper'

class Catalog::CarConceptTest < Cell::TestCase

  test 'show' do
    car = Catalog::Car.new(make: 'Toyota', model: 'Camry', year: '2015')
    page = Structure::Page.new(title: 'Toytota Campry 2015', content: car)
    html = concept('catalog/car/cell', page).call(:show)
    html.assert_text 'Make: Toyota'
    html.assert_text 'Model: Camry'
    html.assert_text 'Year: 2015'
  end


end

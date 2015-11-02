require 'test_helper'

module Structure
  module Menu
    class BaseTest < ActiveSupport::TestCase

      def setup
        @catalog_page = create(:page, title: 'Catalog', slug: 'Catalog', permalink: 'catalog', parent: nil)
        @jeep_page = create(:page, title: 'Jeep', slug: 'jeep', permalink: 'catalog/jeep', parent: @catalog_page)
        @suv_page = create(:page, title: 'SUV', slug: 'suv', permalink: 'catalog/jeep/suv', parent: @jeep_page)
        @compass_page = create(:page, title: 'Compass', slug: 'compass', permalink: 'catalog/jeep/suv/compass', parent: @suv_page)
        @about_page = create(:page, title: 'About Us', slug: 'about', permalink: 'about', parent: nil)
      end

      def expected_tree
        {
          Base.new(@catalog_page) => {
            Base.new(@jeep_page) => {
              Base.new(@suv_page) => {
                Base.new(@compass_page) => {}
              }
            }
          },
          Base.new(@about_page) => {}
        }
      end

      def test_tree
        skip 'do not know how to compatre two hashes'
        assert_equal expected_tree, Base.tree
      end

    end
  end
end

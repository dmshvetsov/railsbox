require 'test_helper'

module Structure
  class PageCreatorTest < ActiveSupport::TestCase

    def subject
      PageCreator
    end

    def valid_attr
      attributes_for(:page)
    end

    def invalid_attr
      { title: nil }
    end

    # Tests
    def test_for_initializer
      assert_instance_of PageCreator, subject.for(Object, {})
    end

    def test_create_pages
      assert subject.for(SectionPage, valid_attr).create.persisted?
    end

    def test_create_page_of_given_type
      assert_instance_of SectionPage, subject.for(SectionPage, valid_attr).create
      assert_instance_of ContentPage, subject.for(ContentPage, valid_attr).create
    end

    def test_create_with_passed_attributes
      a_time = Time.zone.now
      a_page = subject.for(SectionPage, title: 'Catalog', visible: true, published_at: a_time).create

      a_page.reload
      assert_equal a_page.title, 'Catalog'
      assert_equal a_page.visible, true
      assert_equal a_page.published_at, a_time
    end

    def test_do_not_create_if_attr_is_not_valid
      a_page = subject.for(SectionPage, invalid_attr).create
      refute a_page.valid?
      refute a_page.persisted?
    end

    def test_set_permalink_from_slug_for_root_pages
      a_page = subject.for(SectionPage, title: 'About').create
      assert_equal 'about', a_page.permalink
    end

    def test_set_permalink_from_parent_permalink_and_self_slug
      about_page = create(:page, parent: nil, permalink: 'about')
      a_page = subject.for(Page, title: 'Mission', parent: about_page).create
      assert_equal 'about/mission', a_page.permalink
    end

    def test_set_permalink_for_deep_structure
      deep_page = create(:page, permalink: 'catalog/books/tech/computer-science')
      a_page = subject.for(Page, title: 'Algorithms', parent: deep_page).create
      assert_equal 'catalog/books/tech/computer-science/algorithms', a_page.permalink
    end

  end
end

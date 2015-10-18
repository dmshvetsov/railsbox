require 'test_helper'

module Structure
  class PageUpdaterTest < ActiveSupport::TestCase

  def reload_pages
    @information_page.reload
    @about_page.reload
    @policy_page.reload
    @licence_page.reload
  end

  def setup
    @information_page = create(:page, slug: 'information', permalink: nil, parent: nil)
    @about_page = create(:page, slug: 'about', permalink: nil, parent: @information_page)
    @policy_page = create(:page, slug: 'policy', permalink: nil, parent: @information_page)
    @licence_page = create(:page, slug: 'licence', permalink: nil, parent: @policy_page)
    reload_pages
  end

  def subject
    PageUpdater
  end

  # Tests
  def test_for_method_initialize_new_permalink_updater
    assert_instance_of PageUpdater, subject.for(@information_page)
  end

  def test_update_attributes_of_page
    subject.for(@licence_page).update({ title: 'Licence Info', slug: 'lic', parent_id: nil })

    a_page = Page.find(@licence_page.id)
    assert_equal a_page.title, 'Licence Info'
    assert_equal a_page.slug, 'lic'
    assert_equal a_page.parent_id, nil
  end

  def test_update_permalinks_method_if_slug_has_been_changed
    assert_nil @information_page.permalink

    subject.for(@information_page).update({ slug: 'info' })

    assert_equal 'info', @information_page.permalink
  end

  def test_do_not_update_permalinks_method_if_parent_id_has_been_changed
    @information_page.permalink = 'information'
    @information_page.save

    subject.for(@information_page).update({ parent_id: nil })

    assert_equal 'information', @information_page.permalink
  end

  def test_update_permalinks_of_ancestors_of_permalinkable_if_slug_has_been_changed
    assert_nil @about_page.permalink
    assert_nil @policy_page.permalink
    assert_nil @licence_page.permalink

    subject.for(@information_page).update({ slug: 'info' })

    reload_pages

    assert_equal 'info/about', @about_page.permalink
    assert_equal 'info/policy', @policy_page.permalink
    assert_equal 'info/policy/licence', @licence_page.permalink
  end

  def test_do_not_update_if_slug_and_parent_has_not_been_changed
    assert_nil @information_page.permalink
    assert_nil @about_page.permalink
    assert_nil @policy_page.permalink
    assert_nil @licence_page.permalink

    subject.for(@information_page).update({ title: 'info' })

    assert_nil @information_page.permalink
    assert_nil @about_page.permalink
    assert_nil @policy_page.permalink
    assert_nil @licence_page.permalink
  end

  def test_update_ancestors_if_parent_has_been_changed
    assert_nil @about_page.permalink
    assert_nil @policy_page.permalink
    assert_nil @licence_page.permalink

    subject.for(@information_page).update({ parent_id: 9 })

    reload_pages

    assert_equal 'information/about', @about_page.permalink
    assert_equal 'information/policy', @policy_page.permalink
    assert_equal 'information/policy/licence', @licence_page.permalink
  end
  # End of Tests

  end
end

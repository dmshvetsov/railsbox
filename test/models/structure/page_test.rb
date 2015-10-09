require "test_helper"

class Structure::PageTest < ActiveSupport::TestCase

  # Validation tests
  def test_validates_presence_of_title
    page = Structure::Page.new title: nil
    refute page.valid?, 'Expected to be invalid'
    assert_equal page.errors.messages[:title], ["can't be blank"]
  end

  def test_validates_uniqueness_of_title
    create :page, title: 'About'
    page = Structure::Page.new title: 'About'
    refute page.valid?, 'Expected to be invalid'
    assert_equal page.errors.messages[:title], ["has already been taken"]
  end
  # End of validation tests

  def test_autoset_published_at_on_create
    page = create :page, published_at: nil
    assert_not_nil page.published_at
  end

  # Slug tests
  def test_autoset_slug_on_create
    page = create :page, title: 'Must know information', slug: nil
    assert_equal 'must-know-information', page.slug
  end

  def test_autoset_slug_on_create_when_slug_is_empty_string
    page = create :page, title: 'Must know information', slug: ''
    assert_equal 'must-know-information', page.slug
  end

  def test_slug_with_non_english_chars
    I18n.locale = :ru
    page = create :page, title: 'Обязательная к ознакомлению информация'
    assert_equal 'obyazatelnaya-k-oznakomleniyu-informatsiya', page.slug
    # Teardown
    I18n.locale = :en
  end

  def test_change_existed_slug
    page = create :page, slug: 'draft'
    page.update(slug: 'How to contact us')
    page.reload
    assert_equal 'How to contact us', page.slug
  end

  def test_title_change_do_not_change_slug
    page = create :page, slug: 'draft'
    page.update(title: 'How to contact us')
    page.reload
    assert_equal 'draft', page.slug
  end
  # End of slug tests

  # Visibility and publicity tests
  def test_save_published_at_value
    expected_time = 7.days.ago
    page = create :page, published_at: expected_time
    assert_equal expected_time, page.published_at
  end

  def test_published_false
    page = build :page, published_at: 1.hour.from_now
    refute page.published?
  end

  def test_published_false_when_published_at_is_nil
    page = build :page, published_at: nil
    refute page.published?
  end

  def test_published_false_when_published_at_is_empty_string
    page = build :page, published_at: ''
    refute page.published?
  end

  def test_published_true
    page = build :page, published_at: 1.hour.ago
    assert page.published?
  end

  def test_public_when_published_and_visible
    page = build :page, visible: true, published_at: 1.hour.ago
    assert page.public?
  end

  def test_not_public_when_published_and_not_visible
    page = build :page, visible: false, published_at: 1.hour.ago
    refute page.public?
  end

  def test_not_public_when_not_published_and_not_visible
    page = build :page, visible: false, published_at: 1.hour.from_now
    refute page.public?
  end

  def test_not_public_when_not_published_and_visible
    page = build :page, visible: true, published_at: 1.hour.from_now
    refute page.public?
  end

  def test_not_public_when_published_at_is_nil
    page = build :page, visible: true, published_at: nil
    refute page.public?
  end

  def test_not_public_when_published_at_is_empty_string
    page = build :page, visible: true, published_at: ''
    refute page.public?
  end
  # End of visibility and publicity tests

end

require "test_helper"

class Structure::PageTest < ActiveSupport::TestCase

  def test_valid
    page = Structure::Page.new
    assert page.valid?
  end

  def test_autoset_published_at_on_create
    page = Structure::Page.new
    assert_nil page.published_at
    page.save
    assert_not_nil page.published_at
  end

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

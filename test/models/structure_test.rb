require "test_helper"

class StructureTest < ActiveSupport::TestCase

  def test_content_models_default_value
    skip 'do not know how to reset state of module'
    assert_equal [], Structure.content_models
  end

  def test_section_models_default_value
    skip 'do not know how to reset state of module'
    assert_equal [], Structure.section_models
  end

end

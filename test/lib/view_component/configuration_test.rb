require 'test_helper'

module ViewComponent
  class ConfigurationTest < ActiveSupport::TestCase
    def test_has_default_template_dir_attribute
      conf = Configuration.new
      assert_equal 'app/view', conf.template_dir
    end

    def test_override_template_dir_attribute
      conf = Configuration.new(template_dir: 'app/templates')
      assert_equal 'app/templates', conf.template_dir
    end
  end
end

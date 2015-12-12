require 'test_helper'

module Structure
  class StructureTest < ActiveSupport::TestCase

    def test_content_models_default_value
      skip 'do not know how to reset state of module'
      assert_equal [], Structure.content_models
    end

    def test_section_models_default_value
      skip 'do not know how to reset state of module'
      assert_equal [], Structure.section_models
    end

    def test_configuration
      configuration = Configuration.new
      Structure.instance_variable_set('@m_configuration', configuration)
      assert_same configuration, Structure.m_configuration, 'it return memoized configuration object'
    end

    def test_menus
      configuration = Configuration.new
      configuration.menus = [:Main, :Catalog]
      Structure.instance_variable_set('@m_configuration', configuration)
      assert_equal [:Main, :Catalog], Structure.menus, 'it return menu from configuration'
    end

    def test_configure_list_of_menu
      Structure.m_configure do |c|
        c.menus = [:Main, :Footer, :Hidden]
      end
      assert_equal [:Main, :Footer, :Hidden], Structure.menus
    end

  end
end

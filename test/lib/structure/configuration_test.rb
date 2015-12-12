require 'test_helper'

module Structure
  class ConfigurationTest < ActiveSupport::TestCase

    def conf
      @conf ||= Configuration.new
    end

    def test_menus_reader
      conf.instance_variable_set('@menus', [:main_menu])
      assert_equal [:main_menu], conf.menus
    end

    def test_menus_writer
      conf.menus = [:main_menu, :catalog_menu]
      assert_equal [:main_menu, :catalog_menu], conf.instance_variable_get('@menus')
    end

    def test_default_menu
      assert_equal [:main_menu], conf.menus
    end

  end
end

require 'test_helper'

module HelperTestFake
  class BannersWidgetComponent
    def initialize(conf)
    end

    def render
      'Banners widget content'
    end
  end
end

module ViewComponent
  class HelperTest < ActiveSupport::TestCase
    def subject
      client = Class.new do
        include ViewComponent::Helper
      end
      client.new
    end

    def test_component_method_renders_component_by_name
      assert_equal 'Banners widget content', subject.component('HelperTestFake::BannersWidget')
    end
  end
end

require 'test_helper'

module ViewComponent
  class BaseTest < ActiveSupport::TestCase
    # Default test options for
    # ViewComponent::Base class
    def fake_configuration
      conf = Struct.new(:template_dir)
      conf.new('test/fixtures/view')
    end

    def test_render_template_with_erubis_engine
      component = Base.new(fake_configuration)
      result = component.render_template('hello_world/show.html.erb')

      assert_equal "<h1>Hello Erubis!</h1>\n<p>Ruby sign</p>\n", result
    end

    def test_render_template_with_slim_engine
      component = Base.new(fake_configuration)
      result = component.render_template('hello_world/show.html.slim')

      assert_equal "<h1>Hello Slim!</h1><p>Ruby sign</p>", result
    end

    def test_render_template_use_bindings_of_component
      component_class = Class.new(ViewComponent::Base) do
        def title
          'Hello from component helper!'
        end
      end
      component = component_class.new(fake_configuration)
      result = component.render_template('hello_world/bindings.html.erb')

      assert_equal "<h1>Hello from component helper!</h1>\n", result
    end
  end
end

module ViewComponent
  class Base
    def initialize(config)
      @config = config
    end

    def render_template(name)
      case File.extname(name)
      when '.erb'
        tmpl_engine = Erubis::Eruby.new(template_str(name))
        tmpl_engine.result(binding)
      when '.slim'
        tmpl_engine = Slim::Template.new("#{template_dir}/#{name}")
        tmpl_engine.render(binding)
      else
        raise "No engine found for file #{name}"
      end
    end

    def render_react_element
      raise NotImplementedError
    end

    private

    attr_reader :config

    # Directory with templates
    def template_dir
      config.template_dir
    end

    # Template in string representation
    def template_str(template_name)
      File.read(File.path("#{template_dir}/#{template_name}"))
    end
  end
end

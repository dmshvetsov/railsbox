module ViewComponent
  class Configuration
    DEFAULT = {
      template_dir: 'app/view'
    }

    def initialize(template_dir: false)
      @template_dir = template_dir || DEFAULT[:template_dir]
    end

    attr_reader :template_dir
  end
end

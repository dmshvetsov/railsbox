module ViewComponent
  module Helper
    def component(name)
      component_class = "#{name}Component".constantize
      component_class.new(Configuration.new).render
    end
  end
end

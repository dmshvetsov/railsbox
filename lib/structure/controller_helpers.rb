module Structure
  module ControllerHelpers

    def root_page
      @root_page ||= Structure.root_page
    end

    def menu(type = 'main', opts = {})
      menu_class = "#{type.to_s.classify}Menu".constantize
      menu_class.new(params, opts)
    end

    def breadcrumbs
      @breadcumbs ||= Structure::Breadcrumbs::Base.new(@page)
    end

    def self.included(base)
      base.send(:helper_method, :root_page)
      base.send(:helper_method, :menu)
      base.send(:helper_method, :breadcrumbs)
    end

  end
end

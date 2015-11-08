class FooterMenu < Structure::Menu::Base

  DEFAULT_OPTIONS = {
    limit_depth: 1
  }

  def self.pages
    Structure::Page.where(menu: 'MainMenu')
  end

  def self.in_categorizer?
    false
  end

end

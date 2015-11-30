class FooterMenu < Structure::Menu::Base

  DEFAULT_OPTIONS = {
    limit_depth: 1
  }

  def menu_name
    'MainMenu'
  end

  def self.in_categorizer?
    false
  end

end

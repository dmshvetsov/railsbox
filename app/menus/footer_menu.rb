class FooterMenu < Structure::Menu::Base

  DEFAULT_OPTIONS = {
    limit_depth: 1
  }

  def menu_name
    'MainMenu'
  end

end

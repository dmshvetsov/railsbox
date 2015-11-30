class Structure::PagesController < ApplicationController

  def show
    @page = Structure::Page.item(params)
    @concept = @page.build_concept
  end

end

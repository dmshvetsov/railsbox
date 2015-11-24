class Structure::PagesController < ApplicationController

  def show
    @page = Structure::Page.find_by_permalink(params[:permalink])
    @concept = @page.build_concept
  end

end

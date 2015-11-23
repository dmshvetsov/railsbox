class Structure::PagesController < ApplicationController

  def show
    @page = Structure::Page.find_by_permalink(params[:permalink])
    content = @page.content
    content_cell_name = "#{content.class.name}::Cell"
    @concept = concept(content_cell_name, content, page: @page)
  end

end

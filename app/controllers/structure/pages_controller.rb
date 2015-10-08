class Structure::PagesController < ApplicationController

  def show
    @page = Structure::Page.find_by_permalink params[:permalink]
    # TODO: move logic into separate class and test it
    content = @page.content
    content_model_name = content.model_name
    instance_variable_set("@#{content_model_name.singular}", content)

    render "#{content_model_name.plural}/show"
  end

end

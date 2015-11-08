class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def menu(type = 'main', opts = {})
    menu_class = "#{type.to_s.classify}Menu".constantize
    menu_class.new(params, opts)
  end
  helper_method :menu

end

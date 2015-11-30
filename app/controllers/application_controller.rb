class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Structure::ControllerHelpers

  before_action :set_locale

  def default_url_options(options={})
    { language: params[:language] }.merge(options)
  end

  private

  def set_locale
    I18n.locale = params[:language] || I18n.default_locale.to_s
  end

end

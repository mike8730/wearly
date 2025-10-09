class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :set_user, if: :devise_controller?

  private
  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
       username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  def set_user
    @user = resource
  end
end

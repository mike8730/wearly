class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :set_user, if: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_cart

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  def set_user
    @user = resource
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:nickname, :last_name, :first_name, :last_name_kana, :first_name_kana, :birth_date]
    )
  end

  def current_cart
    return nil unless current_user

    current_user.cart || current_user.create_cart
  end
end

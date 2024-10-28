class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges,
  # import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper Devise::Controllers::Helpers

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])


    # Permit confirmed_at for parent registrations if needed
    devise_parameter_sanitizer.permit(:sign_up, keys: [:confirmed_at]) if parent_registration?
  end

  private

  def parent_registration?
    devise_controller? && params[:controller] == 'parents/registrations'
  end
end
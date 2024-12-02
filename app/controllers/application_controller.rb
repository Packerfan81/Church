class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authenticate_admin!
    unless user_signed_in? && current_user.admin?
      redirect_to root_path, alert: 'Access denied.'
    end
  end

  protected

  # Combined configuration for Devise permitted parameters
  def configure_permitted_parameters
  additional_keys = %i[first_name last_name email password password_confirmation]
  devise_parameter_sanitizer.permit(:sign_up, keys: additional_keys)
  devise_parameter_sanitizer.permit(:account_update, keys: additional_keys + [:phone_number])


    # Users
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
    # devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :remember_me])

    # # Parents
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
    # devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])

    # # Custom action for delete (if needed)
    # devise_parameter_sanitizer.permit(:delete, keys: [:email_addresses])

    # #Custom action for Staff Sign In/Up
    # devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
  end

  def user_not_authorized
    Rails.logger.warn "Unauthorized access attempt by #{current_user&.email || 'Guest'}"
    flash[:alert] = "You are not authorized to access this page."
    redirect_to root_path
  end

   def after_sign_up_path_for(resource)
    case resource
    when User
      resource.admin? ? admin_dashboard_path : super
    when Parent
      current_user.admin? ? admin_dashboard_path : super
    else
      super
    end
   end

  def authorize_check_out!
    unless current_user&.admin? || current_user.is_a?(User)
      redirect_to root_path, alert: 'You are not authorized to check out children.'
    end
  end

end
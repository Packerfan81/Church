class Parents::SessionsController < Devise::SessionsController
  skip_before_action :require_no_authentication, only: [:new, :create], if: :admin_signed_in?

  def new
    super
  end

  def create
    super do |resource|
      set_flash_message!(:notice, :signed_in) if is_flashing_format?
      flash[:notice] = "Welcome back, #{resource.first_name}!"
    end
  end

  def destroy
    super
  end

  private

  def after_sign_in_path_for(resource)
    parents_dashboard_path if resource.is_a?(Parent)
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_parent_session_path
  end

  def admin_signed_in?
    current_user&.admin? || false
  end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end
end
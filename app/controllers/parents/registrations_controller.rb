# app/controllers/parents/registrations_controller.rb
class Parents::RegistrationsController < Devise::RegistrationsController
   skip_before_action :require_no_authentication, only: [:new, :create]

  def sign_up_params
    params.require(:parent).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:parent).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation, :current_password)
  end

  def after_sign_up_path_for(resource)
    if resource.is_a?(Admin)
      admin_dashboard_path
    else
      super
    end
  end
end
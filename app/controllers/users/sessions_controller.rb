# app/controllers/users/sessions_controller.rb

class Users::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
   self.resource = warden.authenticate(auth_options)

    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(:user, resource)
      yield resource if block_given?

     redirect_to resource.admin? ? admin_dashboard_path : root_path
    else
      flash.now[:alert] = "Invalid email or password." # Flash message for failed sign-in
      render :new, status: :unprocessable_entity # Re-render the login form
    end
  end


  def destroy
    Rails.logger.debug "Starting user sign out process"
    super
    Rails.logger.debug "User signed out successfully"
  end
end
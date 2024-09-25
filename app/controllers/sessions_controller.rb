class SessionsController < Devise::SessionsController
  helper Devise::Controllers::Helpers

  def new
    super # This calls the default 'new' action from Devise::SessionsController
  end

  def create
    self.resource = warden.authenticate!(auth_options) # Authenticate the user
    set_flash_message!(:notice, :signed_in) # Set a success flash message
    sign_in(resource_name, resource) # Sign in the user
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource) # Redirect after login
  end
end
class SessionsController < Devise::SessionsController
  helper Devise::Controllers::Helpers

  def new
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)

    yield resource if block_given?


    if resource.admin?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      respond_with resource, location: root_path
    end
  end
end
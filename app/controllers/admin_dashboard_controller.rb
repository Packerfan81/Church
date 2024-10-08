class AdminDashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin

  def show

  end

  private

  def authorize_admin
    # Assuming you have a method to check if a user is an admin
    redirect_to @home unless current_user.admin?
  end

end

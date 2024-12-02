class Admin::CheckOutsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def create
    check_in = CheckIn.find_by(id: params[:check_in_id])

    if check_in.nil?
      redirect_to admin_dashboard_path, alert: 'Check-in record not found.' and return
    end

    if check_in.update(check_out_time: Time.current)
      check_in.child.update!(checked_in: false)
      ParentMailer.check_out_notification(check_in).deliver_now if check_in.parent.present?
      redirect_to admin_dashboard_path, notice: "#{check_in.child.full_name} has been checked out successfully!"
    else
      redirect_to admin_dashboard_path, alert: 'An error occurred while checking out the child.'
    end
  end

  private

  def authorize_admin!
    redirect_to root_path, alert: 'Access denied!' unless current_user.admin?
  end
end
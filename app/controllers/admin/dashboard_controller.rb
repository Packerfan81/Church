# app/controllers/admin/dashboard_controller.rb
class Admin::DashboardController < ApplicationController
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :check_admin

  def index
    # Load required data for the dashboard
    @check_ins = CheckIn.where("check_out_time IS NULL OR check_out_time >= ?", 1.hour.ago).includes(:child)
    @children = Child.joins(:check_ins).distinct
    @parents = Parent.all
    @children = Child.includes(:check_ins, :parent) # Eager load check-ins and parent association
    @checked_in_children = Child.joins(:check_ins).where(check_ins: { status: 'checked_in' })
    @users = User.all
    @check_ins = CheckIn.includes(:child, :parent).all # Eager load child and parent associations

    # Debugging logs for inspection
    Rails.logger.debug "Parents loaded: #{@parents.inspect}"
    Rails.logger.debug "Children loaded: #{@children.inspect}"
    Rails.logger.debug "Checked-in children: #{@checked_in_children.inspect}"
    Rails.logger.debug "Users loaded: #{@users.inspect}"
    Rails.logger.debug "Check-ins loaded: #{@check_ins.inspect}"
  end

  private

  def check_admin
    redirect_to root_path, alert: 'Access denied' unless current_user.admin?
  end
end

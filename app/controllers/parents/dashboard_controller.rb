# app/controllers/parents/dashboard_controller.rb
class Parents::DashboardController < ApplicationController
  before_action :authenticate_parent!

  def index
     @children = current_parent.children.includes(:check_ins)

    begin
     @children = Child.where(parent_email: current_parent.email)
      if @children.empty?
        flash.now[:notice] = 'You currently have no children registered.'
      end
    rescue ActiveRecord::AssociationNotFoundError => e
      Rails.logger.error "Error loading children for #{current_parent.email}: #{e.message}"
      @children = []
      flash.now[:alert] = 'There was an issue loading your children. Please try again later.'
    rescue StandardError => e
      Rails.logger.error "Unexpected error for #{current_parent.email}: #{e.message}"
      @children = []
      flash.now[:alert] = 'An unexpected error occurred. Please contact support if the issue persists.'
    end
  end
end
class VolunteersController < ApplicationController
  include Pundit::Authorization
  before_action :authenticate_user!
  before_action :set_volunteer, only: [:show, :edit, :update, :destroy]

  def index
    @volunteers = policy_scope(Volunteer)
  end

  def show
  end

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.new(volunteer_params)
    authorize @volunteer

    if @volunteer.save
      redirect_to @volunteer, notice: "Volunteer created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @volunteer
  end

  def update
    authorize @volunteer
    if @volunteer.update(volunteer_params)
      redirect_to @volunteer, notice: "Volunteer updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @volunteer
    @volunteer.destroy
    redirect_to volunteers_path, notice: "Volunteer was successfully deleted."
  end

  private

  def set_volunteer
    @volunteer = Volunteer.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to volunteers_path, alert: "Volunteer not found."
  end

  def volunteer_params
    params.require(:volunteer).permit(:first_name, :last_name, :email, :phone_number)
  end
end
class Admin::ChildrenController < ApplicationController
  before_action :authenticate_parent!
  before_action :set_child, only: [:edit, :update, :destroy]

  def new
    @child = current_parent.children.new
  end

  def create
    @child = current_parent.children.new(child_params.merge(checked_in: false)) # Explicitly set checked_in
    if @child.save
      redirect_to parents_dashboard_path, notice: "Child added successfully."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @child.update(child_params)
      redirect_to parents_dashboard_path, notice: "Child updated successfully."
    else
      render :edit
    end
  end

  def destroy
    if @child.parent_email == current_parent.email
      @child.check_ins.destroy_all # Optional: cascade delete check-ins
      @child.destroy
      redirect_to parents_dashboard_path, notice: 'Child was successfully deleted.'
    else
      redirect_to parents_dashboard_path, alert: 'You are not authorized to delete this child.'
    end
  end

  private

  def set_child
    @child = current_parent.children.find_by(id: params[:id])
    redirect_to parents_dashboard_path, alert: 'Child not found.' unless @child
  end

  def child_params
    params.require(:child).permit(:first_name, :last_name, :age, :food_allergies, :special_medical_needs, :emergency_contact)
  end
end

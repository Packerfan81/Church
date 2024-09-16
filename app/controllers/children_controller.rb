class ChildrenController < ApplicationController
  before_action :authenticate_user!

  def new
    @parent = Parent.find(params[:parent_id])
    @child = @parent.children.build
  end

  def create
    # ... your existing create logic
  end

  def edit
    @child = Child.find(params[:id])
    authorize @child # If using Pundit
  rescue ActiveRecord::RecordNotFound
    redirect_to parents_path, alert: "Child not found."
  end

  def update
    @child = Child.find(params[:id])
    authorize @child # If using Pundit
    if @child.update(child_params)
      flash[:notice] = "Child information updated successfully."
      redirect_to @child
    else
      render :edit
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to parents_path, alert: "Child not found."
  end

  private

  def child_params
    params.require(:child).permit(:first_name, :last_name, :age, :grade, :food_allergies, :special_medical_needs, :emergency_contact, :classroom_id).tap do |p|
      p.require([:first_name, :last_name])
    end
  end
end
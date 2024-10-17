class ChildrenController < ApplicationController
  before_action :authenticate_user!

  def new
    @parent = Parent.find(params[:parent_id])
    @child = @parent.children.build
  end

  def create
    @parent = Parent.find(params[:parent_id])
    @child = @parent.children.build(child_params)
    if @child.save
      redirect_to @parent, notice: "Child added successfully."
    else
      render :new
    end
  end

  def edit
    @child = Child.find(params[:id])
    authorize @child
  rescue ActiveRecord::RecordNotFound
    redirect_to parents_path, alert: "Child not found."
  end

  def update
    @child = Child.find(params[:id])
    authorize @child
    if @child.update(child_params)
      flash[:notice] = "Child information updated successfully."
      redirect_to parent_child_path(@child.parent, @child)  # Redirect to the child's page
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
# app/controllers/children_controller.rb
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
      if params[:add_another_child] == "1" # Assuming the checkbox value is "1" when checked
        redirect_to new_parent_child_path(@parent), notice: "Child added successfully. Add another child."
      else
        redirect_to new_check_in_path, notice: "All children added. Proceed to check-in."
      end
    else
      render :new
    end
  end

  def edit
    @child = Child.find(params[:id])
  end

  def update
    @child = Child.find(params[:id])
    if @child.update(child_params)
      flash[:notice] = "Child information updated successfully." # Set the flash message
      redirect_to @child
    else
      render :edit
    end
  end

  private

  def child_params
    params.require(:child).permit(:first_name, :last_name, :age, :grade, :food_allergies, :special_medical_needs, :emergency_contact, :classroom_id).tap do |p|
    p.require([:first_name, :last_name]) # Require at least first and last name
    end
  end

end

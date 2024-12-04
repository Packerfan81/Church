module ChildrenControllerConcern
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_parent!
    before_action :set_child, only: [:edit, :update, :destroy]
  end

  def new
    @child = current_parent.children.new
  end

def create
  @child = current_parent.children.build(child_params) # Use `build` to associate parent
  @child.status
  if @child.save
    redirect_to parents_dashboard_path, notice: "Child added successfully."
  else
    Rails.logger.error("Error saving child: #{@child.errors.full_messages}")
    flash.now[:alert] = @child.errors.full_messages.to_sentence
    render :new
  end
end

  def edit
  end

  def update
    if @child.update(child_params)
      redirect_to parents_dashboard_path, notice: "Child updated successfully."
    else
      flash.now[:alert] = @child.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if authorized_to_delete?(@child)
      @child.destroy
      redirect_to parents_dashboard_path, notice: "Child was successfully deleted."
    else
      redirect_to parents_dashboard_path, alert: "You are not authorized to delete this child."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to parents_dashboard_path, alert: "Child not found or you are not authorized to delete this child."
  end

  private

  def set_child
    @child = current_parent.children.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to parents_dashboard_path, alert: "Child not found or you are not authorized to access this child."
  end

  def child_params
    params.require(:child).permit(:first_name, :last_name, :age, :grade, :food_allergies, :special_medical_needs, :emergency_contact, :status, :parent_email, :classroom_id)
  end

  def authorized_to_delete?(child)
    child.parent_email == current_parent.email
  end
end

class ParentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @parents = Parent.all
  end

  def new
    @parent = Parent.new
  end

  def create
    @parent = Parent.new(parent_params)
    if @parent.save
      redirect_to new_parent_child_path(@parent), notice: "Parent created successfully. Please add your child/children."
    else
      render :new
    end
  end

  def show
    @parent = Parent.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to parents_path, alert: "Parent not found."
  end

  def edit
    @parent = Parent.find(params[:id])
  end

  def update
    @parent = Parent.find(params[:id])
    if @parent.update(parent_params)
      redirect_to @parent, notice: "Parent information updated successfully."
    else
      render :edit
    end
  end

def destroy
  @parent = Parent.find(params[:id])
  authorize @parent

  respond_to do |format|
    if @parent.destroy
      format.html { redirect_back(fallback_location: root_path, notice: "Parent was successfully deleted.") }
      format.turbo_stream { flash.now[:notice] = "Parent was successfully deleted." }
    else
      format.html { redirect_back(fallback_location: root_path, alert: "Parent could not be deleted.") }
      format.turbo_stream { flash.now[:alert] = "Parent could not be deleted." }
    end
  end
rescue ActiveRecord::RecordNotFound
  redirect_to parents_path, alert: "Parent not found."
rescue Pundit::NotAuthorizedError
  redirect_to parents_path, alert: "You are not authorized to delete this parent."
end

  def add_child
    @parent = current_user.parent
    if @parent.nil?
      redirect_to new_parent_path, notice: "Please create a parent profile first."
    else
      @child = @parent.children.build
    end
  end

  def create_child
    @parent = current_user.parent
    @child = @parent.children.new(child_params)

    if @child.save
      redirect_to parent_child_path(@parent, @child), notice: "Child added successfully."
    else
      render :add_child
    end
  end

  private

  def child_params
    params.require(:child).permit(:first_name, :last_name, :age, :grade, :food_allergies, :special_medical_needs, :emergency_contact)
  end

  def parent_params
    params.require(:parent).permit(:first_name, :last_name, :phone_number, :email)
  end
end
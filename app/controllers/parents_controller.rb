# app/controllers/parents_controller.rb
class ParentsController < ApplicationController
  include Pundit
  before_action :authenticate_user!, except: [:new, :create]

  def new
    @parent = Parent.new
  end

  def index
    @parents = Parent.all
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
    @parent = Parent.find_by(id: params[:id])
    if @parent
    else
      redirect_to parents_path, alert: "Parent not found."
    end
  end

 def edit
  @parent = Parent.find_by(id: params[:id])
  if @parent
    authorize @parent

  else
    redirect_to parents_path, alert: "Parent not found."
  end
rescue Pundit::NotAuthorizedError
  redirect_to parents_path, alert: "You are not authorized to edit this parent."
end




  def update
    @parent = Parent.find_by(id: params[:id])
    if @parent
      authorize @parent
      if @parent.update(parent_params)
        redirect_to @parent, notice: "Parent information updated successfully."
      else
        render :edit
      end
    else
      redirect_to parents_path, alert: "Parent not found."
    end
  end

  def destroy
    @parent = Parent.find(params[:id])
    authorize @parent
    if @parent.destroy
      redirect_to parents_path, notice: "Parent was successfully deleted."
    else

      redirect_to parents_path, alert: "Parent could not be deleted."
    end
  end

  private

  def parent_params
    params.require(:parent).permit(:first_name, :last_name, :phone_number, :email)
  end
end
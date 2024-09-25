class ParentsController < ApplicationController
  include Pundit::Authorization
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
    @parent = find_and_authorize_parent
  rescue ActiveRecord::RecordNotFound
    redirect_to parents_path, alert: "Parent not found."
  rescue Pundit::NotAuthorizedError
    redirect_to parents_path, alert: "You are not authorized to edit this parent."
  end

  def update
    @parent = find_and_authorize_parent
    if @parent.update(parent_params)
      redirect_to @parent, notice: "Parent information updated successfully."
    else
      render :edit
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to parents_path, alert: "Parent not found."
  rescue Pundit::NotAuthorizedError
    redirect_to parents_path, alert: "You are not authorized to update this parent."
  end

  def destroy
    @parent = find_and_authorize_parent
    if @parent.destroy
      redirect_to parents_path, notice: "Parent was successfully deleted."
    else
      redirect_to parents_path, alert: "Parent could not be deleted."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to parents_path, alert: "Parent not found."
  rescue Pundit::NotAuthorizedError
    redirect_to parents_path, alert: "You are not authorized to delete this parent."
  end

  private

  def find_and_authorize_parent
    parent = Parent.find(params[:id])
    authorize parent
    parent
  end

  def parent_params
    params.require(:parent).permit(:first_name, :last_name, :phone_number, :email)
  end
end
class Admin::ParentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_parent, only: [:edit, :update, :destroy]

  def index
    @parents = Parent.all
  end

  def new
    @parent = Parent.new
  end

  def create
    @parent = Parent.new(parent_params)
    if @parent.save
      redirect_to admin_parents_path, notice: 'Parent created successfully.'
    else
      flash.now[:alert] = @parent.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    # @parent is already set by set_parent
  end

  def update
    authorize @parent if defined?(Pundit)
    if @parent.update(parent_params)
      redirect_to admin_dashboard_path, notice: 'Parent updated successfully.'
    else
      flash.now[:alert] = @parent.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @parent.destroy
      redirect_to admin_dashboard_path, notice: 'Parent deleted successfully.'
    else
      redirect_to admin_dashboard_path, alert: 'Failed to delete parent. Please ensure no children are associated.'
    end
  end

  private

  def set_parent
    @parent = Parent.find_by(id: params[:id])
    redirect_to admin_parents_path, alert: 'Parent not found.' unless @parent
  end

  def parent_params
    params.require(:parent).permit(:email, :first_name, :last_name, :phone_number, :password, :password_confirmation)
  end
end

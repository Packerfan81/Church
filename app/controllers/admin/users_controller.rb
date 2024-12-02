class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  before_action :set_user, only: [:edit, :update, :destroy]



def new
 @user = User.new

end

def create
  @user = User.new(user_params)
  if @user.save
    redirect_to admin_dashboard_path, notice: 'User created successfully.'
  else
    render :new, alert: 'Failed to create user.'
  end
end


  def edit
    # Render the edit form
  end


  def update
    if @user.update(user_params)
      redirect_to admin_dashboard_path, notice: 'User updated successfully.'
    else
      flash.now[:alert] = "Failed to update user: #{@user.errors.full_messages.to_sentence}"
      render :edit
    end
  end


def destroy
  user = User.find_by(id: params[:id])
  if user
    user.destroy
    redirect_to admin_dashboard_path, notice: 'User was successfully deleted.'
  else
    redirect_to admin_dashboard_path, alert: 'User not found.'
  end
end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    if current_user.admin?
      params.require(:user).permit(:first_name, :last_name, :email, :admin)
    else
      params.require(:user).permit(:first_name, :last_name, :email)
    end

  end
end
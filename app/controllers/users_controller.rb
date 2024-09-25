class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create] # Authenticate user for most actions

  def new
    @user = User.new # Initialize a new User object for the 'new' view
  end

  def create
    @user = User.new(user_params) # Create a new User with permitted parameters
    if @user.save
      redirect_to @user, notice: 'User was successfully created.' # Redirect to user profile on success
    else
      render :new # Re-render the 'new' view with errors on failure
    end
  end

  def show
    @user = User.find(params[:id]) # Find the user to display
  end



  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end

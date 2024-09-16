class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def dashboard
    def dashboard
    authorize :admin, :dashboard?
    @parents = Parent.all
    @children = Child.all
    @volunteers = Volunteer.all
    @check_ins = CheckIn.all
    rescue Pundit::NotAuthorizedError
      redirect_to root_path, alert: "You are not authorized to access the admin dashboard."
    end

    @user_search = User.ransack(params[:q])
    @users = @user_search.result

    @check_in_search = CheckIn.ransack(params[:q])
    @check_ins = @check_in_search.result

    @volunteer_search = Volunteer.ransack(params[:q])
    @volunteers = @volunteer_search.result

    @parent_search = Parent.ransack(params[:q])
    @parents = @parent_search.result

    @child_search = Child.ransack(params[:q])
    @children = @child_search.result
  end
  private

  def authorize_admin
    authorize :admin, :dashboard?
  end
end

class UserPolicy < ApplicationPolicy
  def admin?
    user.admin?
  end

  def add_child?
    true
  end

  def create_child?
    true
  end

  def destroy? # Add this method
    user.admin? # Only allow admins to delete users
  end
end
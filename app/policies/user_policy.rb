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
end
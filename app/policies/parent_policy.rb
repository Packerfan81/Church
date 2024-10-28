# app/policies/parent_policy.rb
class ParentPolicy < ApplicationPolicy
  def add_child?
    record == user.parent
  end

  def create_child?
    record == user.parent
  end

  def edit?
    record == user.parent
  end

  def destroy?
    user.admin?
  end

  def update?
    record == user.parent
  end

  def edit?
    admin? # Use the admin? helper method from ApplicationPolicy
  end
end
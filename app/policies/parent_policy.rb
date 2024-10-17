# app/policies/parent_policy.rb
class ParentPolicy < ApplicationPolicy
  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def add_child?
    true
  end

  def create_child?
    true
  end
end
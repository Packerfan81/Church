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
end


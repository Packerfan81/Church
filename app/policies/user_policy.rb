class UserPolicy < ApplicationPolicy
  def admin?
    user.admin?
  end

  def add_child?
    parent?
  end

  def create_child?
    parent?
  end

  def new?
    user.admin? || !user.present?
  end


  def destroy?
    user.admin? && !record.admin?
  end
end

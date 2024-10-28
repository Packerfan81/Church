class CheckInPolicy < ApplicationPolicy


  def create?
    user.present?
  end

  def update?
    true
  end

  def destroy?
    user.admin?
  end

  def edit?
    user.admin?
  end
end
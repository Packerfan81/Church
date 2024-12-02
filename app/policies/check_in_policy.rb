class CheckInPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def edit?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end
end
class AdminDashboardPolicy < ApplicationPolicy
  def show?
    admin?
  end

  def update?
    admin?
  end


  def destroy?
    user.admin? && !record.admin?
  end



end
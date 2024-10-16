class AdminPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def dashboard?
    user.admin?
  end
end
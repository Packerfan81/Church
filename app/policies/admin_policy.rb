class AdminPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def create?
    admin?
  end

  def dashboard?
    admin?
  end
end
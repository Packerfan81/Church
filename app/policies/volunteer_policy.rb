# app/policies/volunteer_policy.rb
class VolunteerPolicy < ApplicationPolicy
  # Define authorization rules for different actions

  def index?
    user.present? # Allow any logged-in user to view the list of volunteers
  end

  def show?
    user.present? # Allow any logged-in user to view volunteer details
  end

  def create?
    user.admin? # Only allow admins to create new volunteers
  end

  def new?
    create? # The 'new' action typically has the same authorization as 'create'
  end

  def edit?
    user.admin? # Only allow admins to edit volunteers
  end

  def update?
    user.admin? # Only allow admins to update volunteers
  end

  def destroy?
    user.admin? # Only allow admins to delete volunteers
  end

  # Scoping for index action (optional)
  class Scope < Scope
    # You can further refine the scope of volunteers visible to different users here if needed
    def resolve
      if user.admin?
        scope.all # Admins can see all volunteers
      else
        scope.none # Non-admins can't see any volunteers (adjust as needed)
      end
    end
  end
end
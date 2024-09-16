# app/policies/check_in_policy.rb
class CheckInPolicy < ApplicationPolicy
  # Define who can perform various actions on CheckIn records

  def create?
    user.present? # Any logged-in user can create a check-in
  end

  def edit?
    user.admin? # Only admins can edit check-ins
  end

  def update?
    edit? # Same rules apply for updating as for editing
  end

  def destroy?
    user.admin? # Only admins can delete check-ins
  end
end
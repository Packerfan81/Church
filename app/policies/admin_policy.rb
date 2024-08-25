class AdminPolicy < ApplicationPolicy
  def dashboard?
    user.admin?
  end
  def dashboard?
  puts "User is admin: #{user.admin?}" # Add this line for debugging
  user.admin?
end
end
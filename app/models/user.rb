# app/models/user.rb
class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :admin

  validates :first_name, :last_name, presence: true # Require first and last name during registration

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    !!admin # Converts admin to a boolean (true/false)
  end
end

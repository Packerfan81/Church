class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

validates :first_name, :last_name, presence: true # Require first and last name during registration

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    self.admin
  end
end

class User < ApplicationRecord


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :email, presence: true, uniqueness: true

  def admin?
    self.admin
  end

  # Instance Methods
  def full_name
    "#{first_name} #{last_name}"
  end
end
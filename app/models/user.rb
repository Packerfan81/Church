class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :admin

  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    !!admin
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      "created_at",
      "email",
      "first_name",
      "id",
      "last_name",
      "updated_at"
    ]
  end
end
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

  has_one :admin
  has_one :parent

  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    admin.present?
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
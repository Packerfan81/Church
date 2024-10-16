class Parent < ApplicationRecord
  has_many :children
  validates :first_name, :last_name, :phone_number, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      "created_at",
      "email",
      "first_name",
      "id",
      "last_name",
      "phone_number",
      "updated_at",
      "full_name_cont"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["children"]
  end
end
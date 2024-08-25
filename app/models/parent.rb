class Parent < ApplicationRecord
  has_many :children
  validates :first_name, :last_name, :phone_number, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }

  def full_name
    "#{first_name} #{last_name}"
  end
end


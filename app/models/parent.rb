class Parent < ApplicationRecord
  # Associations
  has_many :children, dependent: :destroy
  has_many :check_ins, dependent: :destroy

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  # Validations
  validates :first_name, :last_name, :phone_number, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, format: { with: /\A[\d\s\-\(\)]+\z/, message: "is invalid. Use only numbers, spaces, dashes, or parentheses." }
  validates :check_out_preference, presence: true, inclusion: { in: %w[email hard_copy both], message: "%{value} is not a valid preference" }

  # Instance Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    false
  end


end
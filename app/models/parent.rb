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
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :phone_number, format: { with: /\A\d{10}\z/, message: "must be 10 digits long." }
  validates :check_out_preference, presence: true, inclusion: { in: %w[email hard_copy both], message: "%{value} is not a valid preference" }

  # Callbacks
  before_validation :set_default_check_out_preference, on: :create
  before_save :normalize_phone_number

  # Instance Methods
  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def admin?
    false
  end

  private

  def normalize_phone_number
    self.phone_number = phone_number.gsub(/\D/, '') if phone_number.present?
  end

  def set_default_check_out_preference
    self.check_out_preference ||= 'email' # Default to 'email'
  end

end
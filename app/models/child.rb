class Child < ApplicationRecord
  # Associations
  belongs_to :parent, foreign_key: 'parent_email', primary_key: 'email', class_name: 'Parent'
  belongs_to :classroom
  has_many :check_ins, dependent: :destroy
  before_validation :assign_classroom

  # Virtual attributes
  attr_accessor :send_email

  # Validations
  validates :first_name, :last_name, :age, :grade, :food_allergies,
            :special_medical_needs, :emergency_contact, presence: true
  validates :age, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    message: "must be a positive integer"
  }

  def destroy?
    user.is_a?(Parent) && record.parent_email == user.email
  end

  enum status: { pending: 0, checked_in: 0, checked_out: 0 }

  # Constant for classroom age ranges
  CLASSROOM_AGE_RANGES = {
    "Nursery" => 0..2,
    "Kindergarten" => 3..4,
    "1st" => 5..6,
    "2nd" => 7..7,
    "3rd" => 8..8,
    "4th" => 9..9,
    "5th" => 10..10,
    "6th" => 11..12
  }

  # Callbacks


  # Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  # Private methods
  private

  def assign_classroom
    CLASSROOM_AGE_RANGES.each do |classroom_name, age_range|
      if age_range.include?(age)
        self.grade = classroom_name  # Set grade based on age
        self.classroom = Classroom.find_by(name: classroom_name)  # Find corresponding classroom

        if self.classroom.nil?
          errors.add(:classroom, "not found for age group #{age}")
        end
        break
      end
    end
  end
end

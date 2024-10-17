class Child < ApplicationRecord
  belongs_to :parent
  belongs_to :classroom
  before_save :assign_classroom

  validates :first_name, :last_name, :age, :grade, :food_allergies,
            :special_medical_needs, :emergency_contact, presence: true

  validates :age, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    message: "must be a positive integer"
  }

  VALID_GRADES = %w(Nur K 1st 2nd 3rd 4th 5th 6th 1 2 3 4 5 6)
  validates :grade, inclusion: {
    in: VALID_GRADES,
    message: "%{value} is not a valid grade"
  }

  CLASSROOM_AGE_RANGES = {
    "Nursery" => 0..2,    # Ages 0-2
    "Kindergarten" => 3..4, # Ages 3-4
    "1st" => 5..6,        # Ages 5-6
    "2nd" => 7..7,        # Age 7
    "3rd" => 8..8,        # Age 8
    "4th" => 9..9,        # Age 9
    "5th" => 10..10,       # Age 10
    "6th" => 11..12       # Ages 11-12
  }

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name_cont
    [first_name, last_name].join(' ')
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      "age",
      "created_at",
      "emergency_contact",
      "first_name",
      "food_allergies",
      "grade",
      "id",
      "last_name",
      "parent_id",
      "special_medical_needs",
      "updated_at",
      "full_name_cont"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["classroom", "parent"]
  end

  private

  def assign_classroom
    CLASSROOM_AGE_RANGES.each do |classroom_name, age_range|
      if age_range.include?(age)
        self.classroom = Classroom.find_by(name: classroom_name)
        break
      end
    end
  end
end
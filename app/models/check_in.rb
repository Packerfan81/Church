# app/models/check_in.rb
class CheckIn < ApplicationRecord
  belongs_to :child
  belongs_to :volunteer, optional: true
  validates :check_in_time, presence: true
end

# app/models/volunteer.rb
class Volunteer < ApplicationRecord
  has_many :check_ins
  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
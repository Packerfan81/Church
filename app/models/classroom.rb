class Classroom < ApplicationRecord
  has_many :children

  def full_name
    "#{first_name} #{last_name}"
  end




end

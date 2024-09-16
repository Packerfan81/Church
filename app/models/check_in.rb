# app/models/check_in.rb
class CheckIn < ApplicationRecord
  belongs_to :child
  validates :check_in_time, presence: true
end

def full_name
    "#{first_name} #{last_name}"
end

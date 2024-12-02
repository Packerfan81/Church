# app/models/admin.rb
class Admin < ApplicationRecord
  belongs_to :user
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
 def full_name
    "#{first_name} #{last_name}"
 end






def dashboard?
    user.admin?
end

end


# app/models/admin.rb
class Admin < ApplicationRecord
  belongs_to :user
end

# app/models/user.rb
class User < ApplicationRecord
  has_one :admin

  def admin?
    !!admin
  end
end
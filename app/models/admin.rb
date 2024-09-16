# app/models/admin.rb
class Admin < ApplicationRecord
  belongs_to :user
end


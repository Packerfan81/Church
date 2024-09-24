# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

# Create a user first
user = User.create!(
  first_name: 'Jaye',
  last_name: 'Engelhardt',
  email: 'jaye.engelhardt@protonmail.com',
  password: 'password'
)

# Then, create the admin and associate it with the user
Admin.create!(
  first_name: 'Jaye',
  last_name: 'Engelhardt',
  email: 'jaye.engelhardt@protonmail.com',
  password: 'password',
  user: user
)

Classroom.create!(name: "Nursery")
Classroom.create!(name: ["Kindergarten", "K"]) # Comma was missing here
Classroom.create!(name: ["1st", "1"])
Classroom.create!(name: ["2nd", "2"])
Classroom.create!(name: ["3rd", "3"])
Classroom.create!(name: ["4th", "4"])
Classroom.create!(name: ["5th", "5"])
Classroom.create!(name: ["6th", "6"])

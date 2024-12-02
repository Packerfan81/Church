# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

# Seed an admin user
user = User.find_or_initialize_by(email: 'jaye.engelhardt@p.com')

if user.new_record?
  user.update!(
    first_name: 'Jaye',
    last_name: 'Engelhardt',
    password: '123456789',
    admin: true
  )
  puts "User created as admin"
else
  user.update!(
    first_name: 'Jaye',
    last_name: 'Engelhardt',
    admin: true # Ensures the user remains an admin if already created
  )
  puts "User updated to admin"
end

# Seed classrooms
classrooms = %w[Nursery Kindergarten 1st 2nd 3rd 4th 5th 6th]

classrooms.each do |classroom_name|
  Classroom.find_or_create_by!(name: classroom_name)
  puts "Classroom '#{classroom_name}' created or already exists"
end


# This file should contain all the record creation needed to seed the database with its default values.
# The jdata can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# After updating, run 
#   $ rails db:migrate:reset
#   $ rails db:seed

# Create primary sample user.
# create! throws an exception when failing instead of simply returning false
User.create!(name: "Example User", 
             email: "example@railstutorial.org",
             password: "asdfasdf",
             password_confirmation: "asdfasdf",
             admin: true)

# Generate additional random users.
99.times do |n|
  User.create!(name:                  Faker::Name.name,
               email:                 "example-#{n+1}@railstutorial.org", 
               password:              "password",
               password_confirmation: "password")
end
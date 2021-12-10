# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
10.times do
  User.create(email: Faker::Internet.unique.email,
                     username: Faker::Internet.user_name,
                     password: 'password',
                     password_confirmation: 'password')
end

User.limit(10).each do |user|
  user.posts.create(body: "im #{user.username}",
                    images: [open("#{Rails.root}/db/fixtures/dummy1.jpeg"),
                             open("#{Rails.root}/db/fixtures/dummy2.jpeg")
                            ]
                    )
end

FactoryBot.define do
  factoy :post do
    body { Faker::Hacker.say_something_smart }
    images { [File.open("#{Rails.root}/public/images/default.png")] }
    user
  end
end

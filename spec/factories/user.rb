# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    password { 'password' }
    jti { SecureRandom.uuid }
    
  end
end

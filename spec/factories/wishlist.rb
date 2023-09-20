# spec/factories/wishlist.rb
FactoryBot.define do
    factory :wishlist do
      association :user 
      description { FFaker::Lorem.sentence } 
      title { FFaker::Lorem.sentence} 
    end
  end
  
# spec/factories/wishlist.rb
FactoryBot.define do
    factory :wishlist do
      association :user # Предполагаем, что у вас уже есть фабрика для создания пользователя (user)
      description { Faker::Lorem.sentence } # Используем генератор случайного текста для описания
    end
  end
  
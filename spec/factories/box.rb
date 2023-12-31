FactoryBot.define do
    factory :box do
        name { FFaker::Product.product_name }
        dateTo { Date.today + 7.days }
        priceFrom { rand(0..50) }
        priceTo { rand(50..100) }
        place { FFaker::Venue.name }
        description { FFaker::Lorem.paragraph }
        admin { association :user }
        after(:create) do |box|
        box.participants << create_list(:user, 2)
        end
    end
end
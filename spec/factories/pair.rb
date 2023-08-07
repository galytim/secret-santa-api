FactoryBot.define do
    factory :pair do
        giver { association :user }
        recipient { association :user }
        box
    end
end
class Pair < ApplicationRecord
    belongs_to :giver, class_name: 'User', foreign_key: 'giver_id'
    belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
    belongs_to :box

    validates :giver_id, :recipient_id, :box_id, presence: true
end

class Box < ApplicationRecord
    belongs_to :admin, class_name: "User", foreign_key: "admin_id"
    has_and_belongs_to_many :participants, class_name: "User"
    has_many :pairs, dependent: :destroy

    def second_registered_user
        second_user = participants.order("boxes_users.created_at ASC").second
        second_user if second_user.present?
    end
end

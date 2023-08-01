class Box < ApplicationRecord
    belongs_to :admin, class_name: "User", foreign_key: "admin_id"
    has_and_belongs_to_many :participants, class_name: "User"
end

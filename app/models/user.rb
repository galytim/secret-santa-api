class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable,
   :validatable, :jwt_authenticatable, jwt_revocation_strategy: self
   has_many :wishlists
   has_many :administration_boxes, class_name: "Box", foreign_key: "admin_id"
end
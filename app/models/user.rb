class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable,
   :validatable, :jwt_authenticatable, jwt_revocation_strategy: self
   has_many :wishlists, dependent: :destroy
   has_many :administration_boxes, class_name: "Box", foreign_key: "admin_id"

   has_and_belongs_to_many :participated_boxes, class_name: "Box"
   
SEXES = {
    male: 0,
    female: 1,
    unknown: 2
  }


  # Метод для получения имени пола по его значению
  def sex_name
    SEXES.key(self.sex)
  end
end
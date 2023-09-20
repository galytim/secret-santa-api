class Box < ApplicationRecord
    include ImageUploader::Attachment(:image)
    belongs_to :admin, class_name: "User", foreign_key: "admin_id"
    has_and_belongs_to_many :participants, class_name: "User"
    has_many :pairs, dependent: :destroy
    
    def second_registered_user
        second_user = participants.order("boxes_users.created_at ASC").second
        second_user if second_user.present?
    end

    def self.present_box(box, current_user)
        isCurrentUserAdmin = box.admin == current_user
        isStarted = box.pairs.any?
    
        box_data = box.attributes.except('created_at', 'updated_at', 'image')
        box_data.merge(current_user_admin: isCurrentUserAdmin, is_started: isStarted)
    end

    def self.apply_filters(query, filters_data)
        filters_data.each do |filter|
          field = filter[:field]
          search_value = filter[:value]
          next unless field.present? && search_value.present? && Box.column_names.include?(field)
    
          query = query.where("#{field} ILIKE ?", "%#{search_value}%")
        end
        query
      end

end

class Wishlist < ApplicationRecord
    belongs_to :user
    validates :description, presence: true

    scope :filtered_by_field, ->(field, search_value) {
      where("#{field} ILIKE ?", "%#{search_value}%") if column_names.include?(field)
    }
  
    def self.filter_and_present(filters_data, user, page, size)
      wishlists = user.wishlists
  
      if filters_data.present?
        filters_data.each do |filter|
          field = filter[:field]
          search_value = filter[:value]
          next unless field.present? && search_value.present?
  
          wishlists = wishlists.filtered_by_field(field, search_value)
        end
      end
  
      total_count = wishlists.count
      wishlists = wishlists.page(page).per(size)
      wishlists_data = wishlists.map do |wishlist|
        wishlist.attributes.slice('id', 'description')
      end
  
      { items: wishlists_data, totalCount: total_count }
    end
  end
  
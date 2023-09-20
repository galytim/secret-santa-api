class Wishlist < ApplicationRecord
  
  include ImageUploader::Attachment(:image)

  belongs_to :user
    
  validates :description, presence: true
  validates :title, presence: true


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
      {
        id: wishlist.id,
        title: wishlist.title,
        description: wishlist.description,
        user_id: wishlist.user_id,
        image_url: wishlist.image_url
      }
    end
  
    { items: wishlists_data, totalCount: total_count }
  end
  
  
end
  
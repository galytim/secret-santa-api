class WishlistsController < ApplicationController
    before_action :set_wishlist, only: [:show, :update, :destroy]
    before_action :authenticate_user!
    def filtered_index
      filters = params.permit(:page, :size, filters: [:field, :value])
      page = filters[:page]
      size = filters[:size]
      filters_data = filters[:filters]
      user = User.find(params[:user_id])
    
      wishlists = user.wishlists
    
      if filters_data.blank? || filters_data.none? { |filter| filter[:field].present? && filter[:value].present? && Wishlist.column_names.include?(filter[:field]) }
        total_count = wishlists.count
        wishlists_data = wishlists.page(page).per(size).map do |wishlist|
          wishlist_data = wishlist.attributes.except('created_at', 'updated_at')
        end
        render json: { items: wishlists_data, totalCount: total_count }
      else
        result_data = []
        total_count = 0
    
        filters_data.each do |filter|
          field = filter[:field]
          search_value = filter[:value]
          next unless field.present? && search_value.present? && Wishlist.column_names.include?(field)
    
          wishlist_query = wishlists.where("#{field} ILIKE ?", "%#{search_value}%")
          total_count += wishlist_query.count
          wishlist_data = wishlist_query.page(page).per(size).map do |wishlist|
            wishlist.attributes.except('created_at', 'updated_at')
          end
          result_data.concat(wishlist_data)
        end
    
        render json: { items: result_data, totalCount: total_count }
      end
    end
    
    

    def show  
      render json: wishlist_json(@wishlist)
    end
  
    def create
      wishlist = current_user.wishlists.new(wishlist_params)
  
      if wishlist.save
        render json: wishlist_json(wishlist), status: :created
      else
        render json: { errors: wishlist.errors }, status: :unprocessable_entity
      end
    end
  
    def update
      if @wishlist.user == current_user # Проверка, что обновление может выполнять только владелец списка
        if @wishlist.update(wishlist_params)
          render json: wishlist_json(@wishlist)
        else
          render json: { errors: @wishlist.errors }, status: :unprocessable_entity
        end
      else
        render json: { error: "Access denied." }, status: :unauthorized
      end
    end
  
    def destroy
      if @wishlist.user == current_user
        @wishlist.destroy!
        head :no_content
        
      else
        render json: { error: "Access denied." }, status: :unauthorized
      end
    end
  
    private
  
    def set_wishlist
      begin
        @wishlist = Wishlist.find(params[:id])
      rescue ActiveRecord::RecordNotFound
      render json: { error: 'Wishlist not found' }, status: :not_found
    end
    
    end
  
    def wishlist_params
      params.require(:wishlist).permit(:description)
    end

    def wishlist_json(wishlist)
      wishlist.slice(:id, :description, :user_id)
    end
  end
  
class WishlistsController < ApplicationController
    before_action :set_wishlist, only: [:show, :update, :destroy]
    before_action :authenticate_user!
    
    def filtered_index
      filters = params.permit(:page, :size, filters: [:field, :value])
      page = filters[:page]
      size = filters[:size]
      filters_data = filters[:filters]
      user = User.find(params[:user_id])
    
      result = Wishlist.filter_and_present(filters_data, user, page, size)
      render json: result, status: :ok
    end
    
    
    

    def show  
      wishlist = Wishlist.find(params[:id])
      serializer = WishlistSerializer.new(wishlist)
      render json: serializer.serializable_hash
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
      if @wishlist.user == current_user 
        if @wishlist.update(wishlist_params)
          render json: wishlist_json(@wishlist)
        else
          render json: { errors: @wishlist.errors }, status: :unprocessable_entity
        end
      else
        render json: { error: "У тебя нет прав для этого" }, status: :unauthorized
      end
    end
  
    def destroy
      if @wishlist.user == current_user
        @wishlist.destroy!
        head :no_content
        
      else
        render json: { error: "У тебя нет прав для этого" }, status: :unauthorized
      end
    end
  
    private
  
    def set_wishlist
      begin
        @wishlist = Wishlist.find(params[:id])
      rescue ActiveRecord::RecordNotFound
      render json: { error: 'Я не нашел такого вишлиста' }, status: :not_found
      end
    end

    def wishlist_json(wishlist)
      wishlist.slice(:id, :description,:title,:image_url, :user_id)
    end

    def wishlist_params
      params.require(:wishlist).permit(:description,:title,:image)
    end
  end
  
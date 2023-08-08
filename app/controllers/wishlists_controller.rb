class WishlistsController < ApplicationController
    before_action :set_wishlist, only: [:show, :update, :destroy]
    before_action :authenticate_user!
  
    def index
      user = User.find(params[:user_id])
      wishlists = user.wishlists
      wishlists.map do |wishlist|
        wishlist.slice(:id, :description, :user_id)
      end
      render json: wishlists
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
  
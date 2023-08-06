class WishlistsController < ApplicationController
    before_action :set_wishlist, only: [:show, :update, :destroy]
    before_action :authenticate_user!, except: [:index, :show]
  
    def index
      render json: current_user.wishlists
    end
  
    def show
      render json: @wishlist
    end
  
    def create
      wishlist = current_user.wishlists.new(wishlist_params)
  
      if wishlist.save
        render json: wishlist, status: :created
      else
        render json: { errors: wishlist.errors }, status: :unprocessable_entity
      end
    end
  
    def update
      if @wishlist.user == current_user # Проверка, что обновление может выполнять только владелец списка
        if @wishlist.update(wishlist_params)
          render json: @wishlist
        else
          render json: { errors: @wishlist.errors }, status: :unprocessable_entity
        end
      else
        render json: { error: "Access denied." }, status: :unauthorized
      end
    end
  
    def destroy
      if @wishlist.user == current_user # Проверка, что удаление может выполнять только владелец списка
        @wishlist.destroy
        head :no_content
      else
        render json: { error: "Access denied." }, status: :unauthorized
      end
    end
  
    private
  
    def set_wishlist
      @wishlist = Wishlist.find(params[:id])
    end
  
    def wishlist_params
      params.require(:wishlist).permit(:description, :user_id)
    end
  end
  
# app/controllers/users_controller.rb
class UsersController < ApplicationController
    before_action :authenticate_user! # Предполагается, что используется Devise
    before_action :set_user, only: [:show, :update, :destroy]
  
    def show
      render json: @user
    end
  
    def update
      if @user == current_user # Проверка, что обновление может выполнять только текущий пользователь
        if @user.update(user_params)
          render json: @user
        else
          render json: { errors: @user.errors }, status: :unprocessable_entity
        end
      else
        render json: { error: "Access denied." }, status: :unauthorized
      end
    end
  
    def destroy
      if @user == current_user # Проверка, что удаление может выполнять только текущий пользователь
        @user.destroy
        head :no_content
      else
        render json: { error: "Access denied." }, status: :unauthorized
      end
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
  end
  
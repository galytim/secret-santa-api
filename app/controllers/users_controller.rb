# app/controllers/users_controller.rb
class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :update, :destroy]
  
    def show
      render json: user_json
    end
    
    
    
    def update
      if @user == current_user # Проверка, что обновление может выполнять только текущий пользователь
        if @user.update(user_params)
          render json:  user_json
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
      params.require(:user).permit(:name, :dateOfBirth, :sex, :phone, :image)
    end
    
    def user_json
      user_attributes = @user.slice(:id, :name, :email, :sex)
    
      user_attributes[:dateOfBirth] = @user.dateOfBirth.strftime('%Y-%m-%d') if @user.dateOfBirth.present?
      user_attributes[:phone] = @user.phone if @user.phone.present?
      user_attributes[:image_url] =@user.image_url
      user_attributes
    end
  end
  
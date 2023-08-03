# app/controllers/boxes_controller.rb

class BoxesController < ApplicationController
    before_action :set_box, only: [:show, :update, :destroy,:add_participant,:remove_participant]
    before_action :authenticate_user! # Проверка аутентификации пользователя, кроме методов index и show
  
    # GET /boxes
    def index
      render json: current_user.participated_boxes 
    end
  
    # GET /boxes/:id
    def show
      current_user_admin = false
      current_user_admin = true if current_user == @box.admin
      render json: { box: @box, participants: @box.participants, current_user_admin: current_user_admin}
    end
    
    # POST /boxes
    def create
      box = current_user.administration_boxes.build(box_params) # Создание коробки через ассоциацию current_user.administration_box
      if box.save
        box.participants << current_user
        render json: box, status: :created
      else
        render json: { errors: box.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /boxes/:id
    def update
      if @box.admin == current_user
        if @box.update(box_params)
          render json: @box
        else
          render json: { errors: @box.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "You don't have permission to update this box." }, status: :forbidden
      end
    end
  
    # DELETE /boxes/:id
    def destroy
      if @box.admin == current_user
        @box.destroy
        head :no_content
      else
        render json: { error: "You don't have permission to delete this box." }, status: :forbidden
      end
    end
    
    # POST /boxes/:id/add_participant
    def add_participant
        user = User.find(params[:user_id])
    
        if user == current_user || @box.admin == current_user
          if @box.participants.include?(user)
            render json: { error: "User is already a participant in this box." }, status: :unprocessable_entity
          else
            @box.participants << user
            render json: { message: "User successfully added as a participant to this box." }, status: :ok
          end
        else
          render json: { error: "You don't have permission to add this user as a participant." }, status: :forbidden
        end
      end
    
      # DELETE /boxes/:id/remove_participant
      def remove_participant
        user = User.find(params[:user_id])
      
        if current_user == @box.admin
          if user == @box.admin
            new_admin = @box.second_registered_user
      
            if new_admin
              @box.update(admin: new_admin) # или update_attribute(:admin, new_admin)
              @box.participants.delete(user)
      
              render json: { message: "Admin successfully updated." }, status: :ok
            else
              @box.destroy
              head :no_content
            end
          else
            if @box.participants.include?(user)
              @box.participants.delete(user)
              render json: { message: "User successfully removed from participants in this box." }, status: :ok
            else
              render json: { error: "User is not a participant in this box." }, status: :unprocessable_entity
            end
          end
        else
          render json: { error: "You don't have permission to remove this user from participants." }, status: :forbidden
        end
      end
      
    private
  
    def set_box
      @box = Box.find(params[:id])
    end
  
    def box_params
      params.require(:box).permit(:nameBox, :dateFrom, :dateTo, :priceFrom, :priceTo, :place,:description, :image)
    end
  end
  
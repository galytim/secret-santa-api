# app/controllers/boxes_controller.rb

class BoxesController < ApplicationController
    before_action :set_box, only: [:show, :update, :destroy,:add_participant,:remove_participant]
    before_action :authenticate_user!, except: [:index, :show] # Проверка аутентификации пользователя, кроме методов index и show
  
    # GET /boxes
    def index
      boxes = Box.all
      render json: boxes
    end
  
    # GET /boxes/:id
    def show
      render json: @box
    end
  
    # POST /boxes
    def create
      box = current_user.administration_boxes.build(box_params) # Создание коробки через ассоциацию current_user.administration_box
      if box.save
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
    
        if user == current_user || @box.admin == current_user
          if @box.participants.include?(user)
            @box.participants.delete(user)
            render json: { message: "User successfully removed from participants in this box." }, status: :ok
          else
            render json: { error: "User is not a participant in this box." }, status: :unprocessable_entity
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
      params.require(:box).permit(:nameBox, :dateFrom, :dateTo, :priceFrom, :priceTo, :place, :image)
    end
  end
  
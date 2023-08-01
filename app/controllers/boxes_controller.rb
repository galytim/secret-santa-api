# app/controllers/boxes_controller.rb

class BoxesController < ApplicationController
    before_action :set_box, only: [:show, :update, :destroy]
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
  
    private
  
    def set_box
      @box = Box.find(params[:id])
    end
  
    def box_params
      params.require(:box).permit(:nameBox, :dateFrom, :dateTo, :priceFrom, :priceTo, :place, :image)
    end
  end
  
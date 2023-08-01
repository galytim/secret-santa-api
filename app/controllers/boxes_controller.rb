# app/controllers/boxes_controller.rb

class BoxesController < ApplicationController
    before_action :set_box, only: [:show, :update, :destroy]
  
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
      box = Box.new(box_params)
      if box.save
        render json: box, status: :created
      else
        render json: { errors: box.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /boxes/:id
    def update
      if @box.update(box_params)
        render json: @box
      else
        render json: { errors: @box.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    # DELETE /boxes/:id
    def destroy
      @box.destroy
      head :no_content
    end
  
    private
  
    def set_box
      @box = Box.find(params[:id])
    end
  
    def box_params
      params.require(:box).permit(:nameBox, :dateFrom, :dateTo, :priceFrom, :priceTo, :place, :image)
    end
  end
  
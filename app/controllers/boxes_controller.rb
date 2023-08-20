class BoxesController < ApplicationController
  before_action :set_box, except: [:index, :create]
  before_action :authenticate_user!

  # GET /boxes
  def index
    boxes_data = current_user.participated_boxes.map do |box|
      is_сurrent_user_admin = box.admin == current_user
      is_started = box.pairs.any?
      
      box.attributes.except('created_at', 'updated_at', 'image')
          .merge(is_сurrent_user_admin: is_сurrent_user_admin, is_started: is_started)
    end
    
    render json: boxes_data, status: :ok
  end
  
  
  
  # GET /boxes/:id
  def show
    is_сurrent_user_admin = @box.admin == current_user
    is_started = @box.pairs.any?
    recipient = @box.pairs.find_by(giver: current_user)&.recipient
    participants_data = @box.participants.map { |participant| { id: participant.id, name: participant.name, email: participant.email } }

    
    render json: { box: @box.attributes.except('created_at', 'updated_at', 'image'), 
                  participants: participants_data,
                  is_сurrent_user_admin: is_сurrent_user_admin, 
                  recipient: {
                    id: recipient&.id,          
                    name: recipient&.name,
                    email: recipient&.email
                  },
                  is_started: is_started
                }, status: :ok
  end
  # POST /boxes
  def create
    box = current_user.administration_boxes.build(box_params)
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
    
    user = User.find_by(email: params[:email])

    if user.nil?
      render json: { error: "User with the specified email was not found." }, status: :not_found
      return
    end

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
          @box.update(admin: new_admin)
          @box.participants.delete(user)
          render json: { message: "Admin successfully updated." }, status: :ok
        else
          @box.destroy
          head :no_content
        end
      else
        if @box.participants.delete(user)
          render json: { message: "User successfully removed from participants in this box." }, status: :ok
        else
          render json: { error: "User is not a participant in this box." }, status: :unprocessable_entity
        end
      end
    else
      render json: { error: "You don't have permission to remove this user from participants." }, status: :forbidden
    end
  end

  # GET /boxes/:id/start
  def start
    @box = Box.find(params[:id])
  
    # Проверяем, достаточно ли участников для создания хотя бы одной пары
    if @box.participants.size <= 1
      render json: { error: "Not enough participants in this box to start the draw." }, status: :unprocessable_entity
      return
    end
  
    # Проверяем, является ли текущий пользователь администратором коробки
    unless @box.admin == current_user
      render json: { error: "You don't have permission to start this game." }, status: :forbidden
      return
    end
  
    # Обнуляем пары для данной коробки перед запуском розыгрыша
    @box.pairs.destroy_all
  
    # Начинаем розыгрыш
    # Используем each_cons для создания пар участников
    participants = @box.participants.to_a.shuffle
    pairs = participants.each_cons(2).to_a
    pairs << [participants.last, participants.first]
  
    # Для каждой пары создаем запись в таблице Pair
    pairs.each do |pair|
      Pair.create(giver: pair.first, recipient: pair.last, box: @box)
    end
    
    # Формируем JSON в нужном формате
  
    recipient = @box.pairs.find_by(giver: current_user)&.recipient
    render json: {recipient:recipient}, status: :ok
  end
  
  private

  def set_box
    @box = Box.find(params[:id])
  end

  def box_params
    params.require(:box).permit(:nameBox, :dateFrom, :dateTo, :priceFrom, :priceTo, :place, :description, :image)
  end
end

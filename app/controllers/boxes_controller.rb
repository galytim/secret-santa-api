class BoxesController < ApplicationController
  before_action :set_box, except: [:filtered_index,:create]
  before_action :authenticate_user!

  def filtered_index
    filters = params.permit(:page, :size, filters: [:field, :value])
    page = filters[:page]
    size = filters[:size]
    filters_data = filters[:filters]
  
    boxes_query = current_user.participated_boxes
  
    filtered_query = Box.apply_filters(boxes_query, filters_data)
    total_count = filtered_query.count
    boxes = filtered_query.page(page).per(size)
    
    boxes_data = boxes.map { |box| Box.present_box(box, current_user) }
    
    render json: { items: boxes_data, totalCount: total_count }, status: :ok
  end
  
  
  
  
  # GET /boxes/:id
  def show
    is_current_user_admin = @box.admin == current_user
    is_started = @box.pairs.any?
    recipient  = @box.pairs.find_by(giver: current_user)&.recipient
    giver = @box.pairs.find_by(recipient: current_user)&.giver if @box.isCheckResult
    participants_data = @box.participants.map { |participant| { id: participant.id, name: participant.name, email: participant.email } }

    response_hash = {
      box: @box.attributes.except('created_at', 'updated_at', 'image_data').merge(image_url: @box.image_url),
      participants: participants_data,
      is_current_user_admin: is_current_user_admin, 
      recipient: {
        id: recipient&.id,          
        name: recipient&.name,
        email: recipient&.email
      },
      is_started: is_started
    }
    
    # Добавляем giver в JSON только если giver существует
    response_hash[:giver] = {
      id: giver.id,          
      name: giver.name,
      email: giver.email
    } if giver.present?
    
    render json: response_hash, status: :ok
  end    



  # POST /boxes
  def create
    box = current_user.administration_boxes.build(box_params)
    if box.save
      box.participants << current_user
      render json: box_json(box), status: :created
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
      render json: { error: "У тебя нет прав для этого" }, status: :forbidden
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
    unless @box.invitable
      render json: { error: "Эта коробка закрыта для добавления новых участников" }, status: :forbidden
      return
    end
    user = User.find_by(email: params[:email])

    if user.nil?
      render json: { error: "Пользователь не найден" }, status: :not_found
      return
    end

    if user == current_user || @box.admin == current_user
      if @box.participants.include?(user)
        render json: { error: "Пользователь уже в игре" }, status: :unprocessable_entity
      else
        @box.participants << user
        UserMailer.with(user: user).send_invite.deliver_now
        render json: { message: "Круто ты в игре!" }, status: :ok
      end
    else
      render json: { error: "У тебя нет прав на добавление пользователя" }, status: :forbidden
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
          render json: { message: "Админ успешно обновлен" }, status: :ok
        else
          @box.destroy
          head :no_content
        end
      else
        if @box.participants.delete(user)
          render json: { message: "Вы удалили пользователя" }, status: :ok
        else
          render json: { error: "Пользователя и так тут нет" }, status: :unprocessable_entity
        end
      end
    else
      render json: { error: "У тебя нет прав на удаление" }, status: :forbidden
    end
  end

  # GET /boxes/:id/start
  def start
    @box = Box.find(params[:id])
  
    # Проверяем, достаточно ли участников для создания хотя бы одной пары
    if @box.participants.size <= 1
      render json: { error: "Недостаточно игроков для запуска" }, status: :unprocessable_entity
      return
    end
  
    # Проверяем, является ли текущий пользователь администратором коробки
    unless @box.admin == current_user
      render json: { error: "У тебя нет прав для запуска игры" }, status: :forbidden
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
    recipient_data = recipient.slice(:id, :email, :name)
    @box.invitable = false
    @box.save
    

    render json: {
      recipient:recipient_data
      }, status: :ok
  end
  

  def send_start_game 
    @box.participants.each do |user|
      UserMailer.with(user: user).start_game.deliver_now
    end
    render json: {
      message: "Уведомление о запуске коробки разостланы всем участникам"
      }, status: :ok
  end



  private

  def set_box
    @box = Box.find(params[:id])
  end

  def box_params
    params.require(:box).permit(:name, :dateTo, :priceFrom, :priceTo, :place, :description,:isCheckResult,:image)
  end
  def box_json(box)
    box.attributes.except("created_at","updated_at","image_data","image").merge(image_url: box.image_url)
  end
end

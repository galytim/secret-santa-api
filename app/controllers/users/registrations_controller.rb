class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.errors.empty?
      render json: {
        status: { code: 200, message: 'Вы успешно зарегистрировались' },
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }
    else
      # Проверяем, есть ли ошибка валидации уникальности email
      if resource.errors[:email].include?("has already been taken")
        render json: {
          status: { message: "Данная почта уже занята" }
        }, status: :unprocessable_entity
      else
        render json: {
          status: { message: "Извините у нас не получилось создать пользователя, но вы можете попробовать еще раз" }
        }, status: :unprocessable_entity
      end
    end
  end
end

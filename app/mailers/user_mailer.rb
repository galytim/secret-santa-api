#class UserMailer < ApplicationMailer
 #   default from: "galy.tim@gmail.com"    
    #def start_game
    #  @user = params[:user]
    #  mail(to: @user.email, subject: 'Игра запущена!')
    #end

    #def send_invite
    #  @user = params[:user]
    #  mail(to: @user.email, subject: 'Вас пригласили поиграть в тайного Санту!')
    #end 
   #end
    class UserMailer < Devise::Mailer
      default from: "galy.tim@gmail.com" 
      #helper :application # gives access to all helpers defined within `application_helper`.
      include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
      default template_path: 'users/mailer' # to make sure that your mailer uses the devise views
      def reset_password_instructions
        @user = params[:user]
        create_reset_password_token(@user)
        mail(to: @user.email, subject: 'Восстановление пароля')
      end
      private
      def create_reset_password_token(user)
        raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
        @token = raw
        user.reset_password_token = hashed
        user.reset_password_sent_at = Time.now.utc
        user.save
      end
    end

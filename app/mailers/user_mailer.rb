class UserMailer < ApplicationMailer
    default from: "galy.tim@gmail.com"
  
    def start_game
      @user = params[:user]
      mail(to: @user.email, subject: 'Игра запущена!')
    end

    def send_invite
      @user = params[:user]
      mail(to: @user.email, subject: 'Вас пригласили поиграть в тайного Санту!')
    end
  end
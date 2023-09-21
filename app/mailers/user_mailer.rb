class UserMailer < ApplicationMailer
    default from: "galy.tim@gmail.com"
  
    def start_game
      @user = params[:user]
      mail(to: @user.email, subject: 'Игра запущена!')
    end
  end
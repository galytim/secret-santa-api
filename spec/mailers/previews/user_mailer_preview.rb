class UserMailerPreview < ActionMailer::Preview
    def reset_password_instructions
      UserMailer.with(user: User.first).reset_password_instructions.deliver_now
    end
  end
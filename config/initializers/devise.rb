Devise.setup do |config|
  require 'devise/orm/active_record'

  config.navigational_formats = []

  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.devise_jwt_secret_key!
    jwt.dispatch_requests = [
      ['POST', %r{^/login$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/logout$}]
    ]
    jwt.expiration_time = 45000.minutes.to_i
  end

  config.mailer_sender = 'donotreply@example.com'
  config.mailer = 'UserMailer'
  config.reset_password_within = 2.weeks

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 12

  config.reconfirmable = true
  config.password_length = 6..128

  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.sign_out_via = :delete
  config.expire_all_remember_me_on_sign_out = true
  
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end

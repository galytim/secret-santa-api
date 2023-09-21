require "active_support/core_ext/integer/time"

Rails.application.configure do

  config.cache_classes = true


  config.eager_load = true


  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    user_name:Rails.application.credentials.dig(:gmail, :email), 
    password: Rails.application.credentials.dig(:gmail, :password),
    authentication: 'plain',
    enable_starttls_auto: true
  }
  
  config.consider_all_requests_local       = false

  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?


  config.active_storage.service = :local


  config.log_level = :info

  config.log_tags = [ :request_id ]



  config.action_mailer.perform_caching = false


  config.i18n.fallbacks = true


  config.active_support.report_deprecations = false


  config.log_formatter = ::Logger::Formatter.new



  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false
end

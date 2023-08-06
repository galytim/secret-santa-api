RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, type: :view
    config.include Devise::Test::ControllerHelpers, type: :controller
  
  end
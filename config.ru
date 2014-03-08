# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

if Rails.env.production?
  map '/el_user' do
    run ElUser::Application
  end
else
  run ElUser::Application
end

SOCK =      'unix:///tmp/sockets_sllapp.sock'
CTL_SOCK =  'unix:///tmp/sockets_sllapp_ctl.sock'

# environment ENV['RAILS_ENV'] || "development"
pidfile     "tmp/sockets/puma.pid"
state_path  "tmp/sockets/puma.state"

bind SOCK

directory   File.expand_path("..", File.dirname(__FILE__))

activate_control_app CTL_SOCK

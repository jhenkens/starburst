require "starburst/engine"
require "helpers/starburst/configuration"

module Starburst
  extend Configuration

  define_setting :current_user_method, "current_user"
  define_setting :user_instance_methods
  define_setting :cookie_identifier, :starburst_hidden_announcement_ids
end

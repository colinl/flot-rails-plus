require "flot/rails/plus/version"

module Flot
  module Rails
    module Plus
      class Engine < ::Rails::Engine
      end
    end
  end
end

require 'flot/rails/plus/flot_view_helpers'
require 'gon'   # ensure the gon and flot-rails gems are loaded
require 'flot-rails'

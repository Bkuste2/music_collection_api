require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module MusicCollectionApi
  class Application < Rails::Application
    config.load_defaults 7.0
    config.autoload_paths << Rails.root.join('app/errors')

    config.api_only = true
  end
end

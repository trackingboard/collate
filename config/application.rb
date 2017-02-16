require 'rails/all'

module Collate
  class Application < Rails::Application
    config.assets.paths << File.join(Rails.root, "/vendor/pages")
    # config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
    config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

    config.time_zone = 'Pacific Time (US & Canada)'

    # config.active_record.raise_in_transactional_callbacks = true
  end
end

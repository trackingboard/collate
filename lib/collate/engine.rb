require_relative 'active_record_extension'
require 'rails'

module Collate
  class Engine < ::Rails::Engine

    isolate_namespace Collate

    ActiveSupport.on_load :active_record do
      extend Collate::ActiveRecordExtension
    end

  end
end
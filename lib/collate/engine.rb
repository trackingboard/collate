require_relative 'active_record_extension'
require_relative 'action_view_extension'
require 'rails'
require 'active_support/core_ext/string/filters'

module Collate
  class Engine < ::Rails::Engine

    isolate_namespace Collate

    ActiveSupport.on_load :action_view do
      include Collate::ActionViewExtension
    end

    ActiveSupport.on_load :active_record do
      extend Collate::ActiveRecordExtension
    end

    if defined? ActionController::Base
      ActionController::Base.prepend_view_path File.dirname(__FILE__) + "/../app/views"
    end
  end
end
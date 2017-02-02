$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
ENV['RAILS_ENV'] ||= 'test'
require 'collate'
require File.expand_path('../../config/environment', __FILE__)

require 'simplecov'
SimpleCov.start 'rails'

require 'rails/test_help'
require 'minitest/pride'
require 'minitest/hell'
require 'pry-rescue/minitest' if ENV['PRY'].present?

require 'minitest/autorun'

require 'active_record'


load File.dirname(__FILE__) + '/schema.rb'

load File.dirname(__FILE__) + '/seeds.rb'
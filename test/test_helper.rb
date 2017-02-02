require 'simplecov'

if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
  SimpleCov.coverage_dir(dir)
end

SimpleCov.start 'rails'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
ENV['RAILS_ENV'] ||= 'test'
require 'collate'
require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'minitest/pride'
require 'minitest/hell'
require 'pry-rescue/minitest' if ENV['PRY'].present?

require 'minitest/autorun'

require 'active_record'


load File.dirname(__FILE__) + '/schema.rb'

load File.dirname(__FILE__) + '/seeds.rb'
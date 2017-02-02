$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'collate'

require 'minitest/autorun'

require 'active_record'

# ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
ActiveRecord::Base.establish_connection(adapter: 'postgresql',
  encoding: 'unicode', database: 'collate_test', username: 'postgres')

load File.dirname(__FILE__) + '/schema.rb'
require File.dirname(__FILE__) + '/models.rb'
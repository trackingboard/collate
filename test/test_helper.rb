$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'collate'

require 'minitest/autorun'

require 'active_record'

require 'pg'

conn = PG.connect :host => 'localhost', :user => 'postgres'
conn.exec "SET client_min_messages TO ERROR"
conn.exec "DROP DATABASE IF EXISTS collate_test"
conn.exec "CREATE DATABASE collate_test"

ActiveRecord::Base.establish_connection(adapter: 'postgresql',
  encoding: 'unicode', database: 'collate_test', username: 'postgres')

load File.dirname(__FILE__) + '/schema.rb'
require File.dirname(__FILE__) + '/models.rb'
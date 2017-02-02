class Movie < ActiveRecord::Base
  collate_on :name
end